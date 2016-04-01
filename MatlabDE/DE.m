function best = DE(D, NP, n, minB, maxB, eval, feedback)
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
    
    
    
    % --- randomly initialize population --- %
    pop = (maxB - minB) .* rand(D, NP) + minB;
    
    score = eval(pop);
    
    popStd = ones(1,NP);
    
    alpha = 0.06;
    d = 0.1;
    zeta = 1;
    diversify = @(mutation, g) diversifier(mutation, g, n, D, alpha, d, zeta);
    
    f = 0.85;              %scale factor/mutation factor ("mutation" weight)
    cr = 0.25;        %crossover propability
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
        
        if nargin > 6 && (mod(g/n,0.05) == 0 || g == 1)
           feedback(g);
           disp(['Minimum error ' num2str(min(score), 10) ' at generation ' num2str(g) '.']);
        end
    end
    
    score = eval(pop);
    [~, index] = min(score(:));
    best = pop(1:D,index);
end
