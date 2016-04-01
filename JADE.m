function [ output_args ] = JADE(D, NP, n, minB, maxB, func, func_args)
    % JADE(D, NP, n, minB, maxB, func, func_args*)
    %
    % D:            dimensions number
    % NP:           population size
    % n:            maximum number of generations
    % minB:         minumum boundary
    % maxB:         maximum boundary
    % func:         function to be minimized
    % func_args:    any extra arguments that 'func' may need
    % *:            optional arguments
    
    addpath('MatlabDE');
    
    if nargin < 6 || nargin > 7
        disp('Usage: JADE(D, NP, n, minB, maxB, func, func_args*)');
        disp('       *optional arguments');
        return;
    elseif nargin ~= 7
        func_args = {};
    end
    
    mcr = 0.5;     %µCR
    mf = 0.5;      %µF
    c_m = 0.35;
    
    maxASize = NP;
    A = zeros(D, maxASize);
    archive = @(A, archiveSize, improvements) archiver(A, D, maxASize, archiveSize, improvements);
    archiveSize = 0;
    
    g = 0;                  %generation
    
    d = 0.1;
    alpha = 0.06;
    zeta = 1;
    diversify = @(mutation, g) diversifier(mutation, g, n, D, alpha, d, zeta);
    
    p = 0.9;
    top = round(NP*(1-p));

    % --- randomly initialize population --- %
    pop = (maxB - minB) .* rand(D, NP) + minB;
    
    score = func(pop, func_args);

    popStd = ones(D,1);
    
    progressBar = '[                    ]';
    progress = 1;
    disp([progressBar(1:end/2) '0.00%' progressBar(end/2+1:end)]);
    
    %Lehmer mean
    meanl = @(x) sum(x.^2)/sum(x);

    tic

    while g < n && ~isempty(popStd(popStd > 0))
        g = g + 1;
        
        [~, scoreOrdering] = sort(score(:),'ascend');
        pBest = scoreOrdering(1:top);
        best = pop(1:D, pBest(randi(top, [1 NP])));
        
        cr = mcr + 0.1 * randn(1,NP);
        
        % --- set up cauchy distrubuition -- %
        pd = makedist('tLocationScale','mu',mcr,'sigma',0.1,'nu',1);
        f = random(pd,1,NP);
        negatives = f < 0;
        while(~isempty(negatives(negatives == true)))
          newF = random(pd,1,NP);
          f(negatives) = newF(negatives);
          negatives = f < 0;
        end
        f(f > 1) = 1;
        
        %-------- determine wether to cross or not --------%
        cross = zeros(D, NP);
        CRCross = rand(D, NP);
        for i=1:D
          cross(i,1:NP) = randi(D, 1, NP) == i;
          CRCross(i,1:NP) = CRCross(i,1:NP) < cr;
        end
        cross = cross | CRCross;
        %--------------------------------------------------%

        oldScore = score;
        popOld = pop;


        [x, mutation, restore] = mutator(g, pop, diversify, A, archiveSize);
        %mutation = ((best - pop(1:D,x)) + mutation) .* cross;   %literature
        mutation = (best - pop(1:D,x)) + mutation .* cross;     %better results
        pop = pop(1:D,x) + bsxfun(@times,f,mutation);
        
        pop(pop>maxB) = maxB;
        pop(pop<minB) = minB;
        
        pop(restore) = popOld(restore);
        
        score = func(pop, func_args);

        improved = score > oldScore;
        worse = score > oldScore;
        
        % -------- restore individuals who got worse from previous generation  -------- %
        pop(:,worse) = popOld(:,worse);
        
        %-------- save good solutions to the archive --------%
        improvements = pop(1:D, improved);

        [ A, archiveSize ] = archive(A, archiveSize, improvements);
        %----------------------------------------------------%
        
        SCR = cr(improved);
        SF = cr(improved);
        
        mean_scr = 0;
        if ~isempty(SCR)
            mean_scr = mean(SCR);
        end
        mean_sf = 0;
        if ~isempty(SF)
            mean_sf = meanl(SF);
        end

        mcr = (1-c_m) * mcr + c_m * mean_scr;
        mf = (1 - c_m) * mf + c_m * mean_sf;

        popStd = std(pop,1,2);   
        
        percentage = g/n*100;
        if(mod(percentage,5) == 0)
            progress = progress + 1;
            progressBar(progress) = '=';
            progressBar(progress+1) = '>';
            tempArgs = func_args;
            tempArgs{end+1} = true;
            info = func(pop, tempArgs);
            out = plotBestFilter(info);
            drawnow;
            clc;
            disp([progressBar(1:end/2) sprintf('%1.2f',percentage) '%' progressBar(end/2+1:end)]);
             toc;
            disp(['Error ' num2str(out(1), 10) ' at generation ' num2str(g) '.']);
        end
    end
    
    score = func(pop, func_args);
    
    [error, index] = min(score);
%     disp(['Finished after ' num2str(g) ' generations.']);
%     disp(['Error ' num2str(error, 10) '.']);
    
    output_args = pop(:,index);

end
