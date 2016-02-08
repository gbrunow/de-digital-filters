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
    
    if nargin < 6 || nargin > 7
        disp('Usage: JADE(D, NP, n, minB, maxB, func, func_args*)');
        disp('       *optional arguments');
        return;
    elseif nargin ~= 7
        func_args = {};
    end
    
    G = 0;                  %generation
    F = ones(D,NP);         %scale factor/mutation factor ("mutation" weight)
    CR = ones(1,NP)*0.25;   %crossover propability
    
    d = 0.1;
    alpha = 0.06;
    zeta = 1;

    P = 0.9;
    mCR = ones(1,NP) * 0.5;     %µCR
    mF = ones(1,NP) * 0.5;      %µF
    C = 0.35;
    SCR = [];                   %List of successfull probabilities CR
    SF = [];                    %List of successfull scale factors F

    top = round(NP*(1-P));

    pop = (maxB - minB) .* rand(D, NP) + minB;
   
    
    score = func(pop, func_args);

    pop_std = ones(D,1);
    
    progress_bar = '[                    ]';
    progress = 1;
    disp(progress_bar);
    disp('0%');

    tic

    while G < n && ~isempty(pop_std(pop_std > 0))
        G = G + 1;
        pop_old = pop;

        [a, b, c] = randPop(NP,D);

        pop_a = pop(:,a);
        pop_b = pop(:,b);
        pop_c = pop(:,c);

        %-------- determine wether to cross or not --------%
        randJ = randi(D, [D NP]);       %random dimension matrix
        cross = zeros(size(randJ));
        for j = 1:D
            cross(j,:) = randJ(j,:) == j;
        end
        CR_cross = bsxfun(@lt, rand([D NP]), CR);
        cross =  CR_cross | cross;
        %--------------------------------------------------%

        old_score = score;
            
        score = func(pop, func_args);
            
        [sortedValues,sortIndex] = sort(score(:),'descend');
        p_best = pop(:,sortIndex(1:top));
        best = p_best(:,randi(top));
              
        mCR = (1-C) * mCR + C * mean(SCR);
        CR = mean(mCR) + 0.1 * randn(1,NP);

        Fi = mF + 0.1 * randn(1,NP); % !!! This is standard distribuited but should be Cauchy !!!
        Fi(Fi > 1) = 1;
        third = randi(NP,[1 floor(NP/3)]);
        Fi(third) = 1.2*rand(1,floor(NP/3));
        F = bsxfun(@times,Fi,F);

        pop = pop_a + bsxfun(@minus,best,pop) + (pop_b - pop_c) .* F .* cross;
        pop(pop>maxB) = maxB;
        pop(pop<minB) = minB;

        pop_diff = abs(pop_old - pop);

        %------- population diversification -------%
        threshold = alpha*d*((n-G)/G)^zeta;

        less_than_threshold = pop_diff < threshold;
        skip_vector = sum(less_than_threshold) > 0;
        if ~isempty(pop(less_than_threshold))

            [a, b, c] = randPop(NP,D,skip_vector);

            pop_a = pop(:,a);
            pop_b = pop(:,b);
            pop_c = pop(:,c);

            mutation = pop_b(less_than_threshold) - pop_c(less_than_threshold);
            mutation = mutation .* F(less_than_threshold);

            pop(less_than_threshold) = pop_a(less_than_threshold) + mutation .* cross(less_than_threshold);

        end
        %------------------------------------------%

        old_score = score;
        
        score = func(pop, func_args);
            
        pop(:,score > old_score) = pop_old(:,score > old_score);

        SCR = [SCR CR(score > old_score)];
        SF = [SF CR(score > old_score)];

        meanL = sum(Fi.^2)/sum(Fi);
        mf = (1 - C) * mF + C * meanL;

        pop_std = std(pop,1,2);   
        
        percentage = G/n*100;
        if(mod(percentage,5) == 0)
            progress = progress + 1;
            progress_bar(progress) = '=';
            progress_bar(progress+1) = '>';
            tempArgs = func_args;
            tempArgs{end+1} = true;
            info = func(pop, tempArgs);
            out = plotBestFilter(info);
            drawnow;
            clc;            
            toc
            disp(['Error ' num2str(out(1), 10) ' at generation ' num2str(G) '.']);
            disp(progress_bar);
            disp([sprintf('%1.2f',percentage) '%']);
        end
    end
    
    score = func(pop, func_args);
    
    [error, index] = min(score);
%     disp(['Finished after ' num2str(G) ' generations.']);
%     disp(['Error ' num2str(error, 10) '.']);
    
    output_args = pop(:,index);

end
