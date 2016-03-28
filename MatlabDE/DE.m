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
        mutation = f * mutation .* cross;
        
        pop = pop(1:D,x) + mutation;
        
        pop(pop > maxB) = maxB;
        pop(pop < minB) = minB;
        
        score = eval(pop);
        
        %improved = score > oldScore;
        worse = score > oldScore;
        
        % -------- restore individuals who got worse from previous generation  -------- %
        %pop(:, ~improved) = popOld(:, ~improved);
        pop(:, worse) = popOld(:, worse);


        popStd = std(pop,1,2);
        
        clc
        g
    end
    
    score = eval(pop);
    [~, index] = min(score(:));
    best = pop(1:D,index);
end

