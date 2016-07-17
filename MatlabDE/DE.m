function best = DE(D, NP, n, minB, maxB, f, cr, eval, feedback)
%   JADE(D, NP, n, minB, maxB, maxAsize, eval, feedback)
%
%   D:         number of dimensions the problem has
%   NP:        population size
%   n:         maximum number of generations
%   minB:      minumum boundary
%   maxB:      maximum boundary
%   f:         scale factor/mutation factor ("mutation" weight)
%   cr:        crossover propability
%   maxASize:  archive of improved solutions maximum size
%   eval:      cost function
%   feedback:  feedback function
    
    
    
    % --- randomly initialize population --- %
    pop = (maxB - minB) .* rand(D, NP) + minB;
    
    score = eval(pop);
    
    popStd = ones(1,NP);
    
    alpha = 0.06;
    d = 0.1;
    zeta = 1;
    diversify = @(mutation, g) diversifier(mutation, g, n, D, alpha, d, zeta);
    
    g = 0 ;                      %generation
    
    while g < n && ~isempty(popStd(popStd > 0))
        g = g + 1;
        
        %-------- determine wether to cross or not --------%
        cross = zeros(D, NP);
        CRCross = rand(D, NP);
        for i=1:D
          cross(i,1:NP) = randi(D, 1, NP) == i;
          %CRCross(i,1:NP) = CRCross(i,1:NP) < cr;
        end
        cross = cross | CRCross < cr;
        %--------------------------------------------------%

        oldScore = score;
        popOld = pop;
        
%         [x, mutation] = mutator(g, pop);
        [x, mutation] = mutator(g, pop, diversify);
        
        pop = pop(1:D,x) + f * mutation .* cross;
        
        pop(pop > maxB) = maxB;
        pop(pop < minB) = minB;
        
        score = eval(pop);
        
        worse = score > oldScore;
        
        % -------- restore individuals who got worse from previous generation  -------- %
        pop(:, worse) = popOld(:, worse);
        score(worse) = oldScore(worse);

        popStd = std(pop,1,2);
        
        if nargin > 6 && (mod((g-1)/n,0.025) == 0)
           feedback((g/n),['Minimum MSE ' num2str(min(score), '%10.5e') ' at generation ' num2str(g) '.']);
        end
    end
    
    score = eval(pop);
    [~, index] = min(score(:));
    best = pop(1:D,index);
end

