function best = SHADE(D, NP, n, minB, maxB, maxASize, eval, feedback)
%   SHADE(D, NP, n, minB, maxB, maxAsize, eval, feedback)
%
%   D:         number of dimensions the problem has
%   NP:        population size
%   n:         maximum number of generations
%   minB:      minumum boundary
%   maxB:      maximum boundary
%   maxASize:  archive of improved solutions maximum size
%   eval:      cost function
%   feedback:  feedback function
    
    H = 25;
    mcr = ones(1,H)*0.5;
    mf = ones(1,H)*0.5;
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
    
    p = 0.1;                     %determine the percentage (1-p) of top candidates
    pmin = 2/NP;
    
    top = round(NP*(p));       %number of top candidates
    
    c_m = 0.35;
    
    %Lehmer mean
    %meanl = @(x) sum(x.^2)/sum(x);
    
    k = 1;
    best = zeros(D, NP);
    
    while g < n && ~isempty(popStd(popStd > 0))
        g = g + 1;
        
        [~, scoreOrdering] = sort(score(:),'ascend');
        
        p = pmin + (0.2-pmin).*rand([1 NP]);
        top = round(p*NP);
        
        for i = 1:NP
            pBest = scoreOrdering(1:top(i));
            best(:, i) = pop(:, pBest(randi(top(i))));
        end
        
        r = randi(H, [1 NP]);
        
        cr = normrnd(mcr(r), 0.1, [1 NP]);
        cr(cr > 1) = 1;
        cr(cr < 0) = 0;
        
        f = normrnd(mf(r), 0.1, [1 NP]); %should be cauchy distribuited but is normally distribuited
        negatives = f < 0;
        while(~isempty(negatives(negatives == true)))
          newF = normrnd(mf(r), 0.1, [1 NP]);
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
%         parentVectors = popOld(1:D, improved);
        parentVectors = pop(1:D, improved);

        [ A, archiveSize ] = archive(A, archiveSize, parentVectors);
        %-----------------------------------------------------------------------------%

        scr = cr(improved);
        sf = f(improved);
        
        if ~isempty(improved) && sum(scr) > 0
            deltaScore = abs(score(improved) - oldScore(improved));            
            wk = deltaScore./sum(deltaScore);
            
            mean_scr = meanw(scr, wk);
            mean_sf = meanlw(sf, wk);
            
            mcr(k) = mean_scr;
            mf(k) = mean_sf;
            
            if k > H
                k = 1;
            else
                k = k + 1;
            end
        end

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

