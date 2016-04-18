function best = JADE(D, NP, n, minB, maxB, maxASize, eval, feedback)
%   JADE(D, NP, n, minB, maxB, maxAsize, eval, feedback)
%
%   D:         number of dimensions the problem has
%   NP:        population size
%   n:         maximum number of generations
%   minB:      minumum boundary
%   maxB:      maximum boundary
%   maxASize:  archive of improved solutions maximum size
%   eval:      cost function
%   feedback:  feedback function
    
    mcr = 0.5;
    mf = 0.5;
    mean_scr = 0.5;
    mean_sf = 0.5;
    A = zeros(D, maxASize);
    archive = @(A, archiveSize, improvements) archiver(A, D, maxASize, archiveSize, improvements);
    archiveSize = 0;
    
    % --- randomly initialize population --- %
    pop = (maxB - minB) .* rand(D, NP) + minB;
    
    score = eval(pop);
    
    popStd = ones(1,NP);
    
    %f = ones(D,NP);              %scale factor/mutation factor ("mutation" weight)
    %cr = ones(1,NP)*0.25;        %crossover propability
    g = 0 ;                      %generation
    
    alpha = 0.06;
    d = 0.1;
    zeta = 1;
    diversify = @(mutation, g) diversifier(mutation, g, n, D, alpha, d, zeta);
    
    p = 0.9;                     %determine the percentage (1-p) of top candidates
    top = round(NP*(1-p));       %number of top candidates
    
    c_m = 0.35;
    
    %Lehmer mean
    meanl = @(x) sum(x.^2)/sum(x);
    
    while g < n && ~isempty(popStd(popStd > 0))
        g = g + 1;
        
        [~, scoreOrdering] = sort(score(:),'ascend');
        pBest = scoreOrdering(1:top);
        best = pop(1:D, pBest(randi(top, [1 NP])));
        
        cr = normrnd(mcr, 0.1, [1 NP]);
        cr(cr > 1) = 1;
        cr(cr < 0) = 0;
        
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
        mutation = ((best - pop(1:D,x)) + mutation) .* cross;
        pop = pop(1:D,x) + bsxfun(@times,f,mutation);
        
        pop(pop > maxB) = maxB;
        pop(pop < minB) = minB;
        
        pop(restore) = popOld(restore);
        
        score = eval(pop);
        
        improved = score < oldScore;
        worse = score > oldScore;
        
        %-------- restore individuals who got worse from previous generation  --------%
        pop(:, worse) = popOld(:, worse);
        score(worse) = oldScore(worse);

        %-------- save parent vectors worse than trial vectors to the archive --------%
        %-------- in orther to maintain diversity                             --------%
        parentVectors = popOld(1:D, improved);

        [ A, archiveSize ] = archive(A, archiveSize, parentVectors);
        %-----------------------------------------------------------------------------%

        scr = cr(improved);
        sf = f(improved);
        
        if ~isempty(scr)
            mean_scr = mean(scr);
        end
        
        if ~isempty(sf)
            deltaScore = abs(score(improved) - oldScore(improved));            
            wk = deltaScore/(sum(scr)*deltaScore);
            mean_sf = meanlw(sf, wk);
        end

        mcr =  (1 - c_m) * mcr + c_m * mean_scr;
        mf = (1 - c_m) * mf + c_m * mean_sf;

        popStd = std(pop,1,2);
        
        if nargin > 7 && (mod((g-1)/n,0.025) == 0)
           feedback((g/n),['Minimum MSE ' num2str(min(score), '%10.5e') ' at generation ' num2str(g) '.']);
        end
    end
    
    score = eval(pop);
    [bestScore, index] = min(score(:));
    best = pop(1:D,index);
    if nargin > 7
        feedback((g/n),['Minimum MSE ' num2str(min(bestScore), '%10.5e') ' at generation ' num2str(g) '.']);
    end
end

