D = 2;
n = 2500;

a = 1;
b = 100;
rosenbrock = @(pop) (a - pop(1,:)).^2 + b*(pop(2,:) - pop(1,:).^2).^2;

A = 10;
N = 2;
rastrigin = @(pop) A*N + sum(pop.^2 - A*cos(2*pi*pop));

tic
evaluation = zeros(D,100);
progress(0,'Please wait...');
for i = 1:100
    best = JADE(D, 25, n, -2, 2, 25, rastrigin);
    evaluation(:,i) = best;
    progress(i/100,'Please wait...');
end

rstd = std(evaluation,1,2)
rmean = mean(evaluation,2)
rmin = [min(evaluation(1,:)); min(evaluation(2,:))]
rmax = [max(evaluation(1,:)); max(evaluation(2,:))]
