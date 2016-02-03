% clear all;
close all;
% clc;

NP = 25;                %population size
F = 0.85;               %scale factor ("mutation" weight)
CR = 0.25;              %crossover propability
D = 2;                  %dimensions
G = 0;                  %generation
min_bound = -2;
max_bound = 2;
max_iterations = 2500;

n = max_iterations;
d = 0.1;
alpha = 0.06;
zeta = 1;

functions = { 'rosenbrock', 'rastrigin' };
properties.function = functions{1};
properties.dimensions = D;
properties.fill = true;
properties.plot = false;
properties.levels = 20;

D = properties.dimensions;

pop = (max_bound - min_bound) .* rand(D, NP) + min_bound;
plot_pop(pop, max_bound, properties);

tic

acc_diff = zeros(D,NP);

pop_std = ones(D,1);

while G < max_iterations && ~isempty(pop_std(pop_std > 0))
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
    
    cross = rand([D NP]) < CR | cross;
    %--------------------------------------------------%
    
    pop = pop_a + F * (pop_b - pop_c) .* cross;
    pop(pop>max_bound) = max_bound;
    pop(pop<min_bound) = min_bound;
    
    
    pop_diff = abs(pop_old - pop);
    acc_diff = acc_diff + pop_diff;
    
    %------- population diversification -------%
    threshold = alpha*d*((n-G)/G)^zeta;
    
    less_than_threshold = pop_diff < threshold;
    skip_vector = sum(less_than_threshold) > 0;
    if ~isempty(pop(less_than_threshold))
        
        [a, b, c] = randPop(NP,D,skip_vector);

        pop_a = pop(:,a);
        pop_b = pop(:,b);
        pop_c = pop(:,c);
        
        pop(less_than_threshold) = pop_a(less_than_threshold) + F * (pop_b(less_than_threshold) - pop_c(less_than_threshold)) .* cross(less_than_threshold);
        
    end
    %------------------------------------------%
    
    score = benchmark_func(pop, properties);
    old_score = benchmark_func(pop_old, properties);
    pop(:,score > old_score) = pop_old(:,score > old_score);
    
    pop_std = std(pop,1,2);

%   ----------- Progression Plot ----------- 
    if(max(acc_diff(:)) >= 0.05 && D == 2)
        pop_diff = zeros(D,NP);
        plot_pop(pop, max_bound, properties);
%         clc;
%         threshold
    end    
%   ----------------------------------------    

end

toc

plot_pop(pop, max_bound, properties);
score = benchmark_func(pop, properties);
[val index] = min(score);
G
result = pop(:,index)
hold on;
plot([min_bound result(1,1)], [result(2,1) result(2,1)], 'k--');
plot([result(1,1) result(1,1)], [min_bound result(2,1)], 'k--');
plot(result(1,1), result(2,1), 'mo', 'LineWidth', 3);
