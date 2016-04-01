a = 1;
b = 100;
rosenbrock = @(pop) (a - pop(1,:)).^2 + b*(pop(2,:) - pop(1,:).^2).^2;

A = 10;
n = 2;
rastrigin = @(pop) A*n + sum(pop.^2 - A*cos(2*pi*pop));

D = 2;
n = 2500;
tic
feedback = @(g) progressBar(30,g,n,true,true,true);

evaluation = zeros(D,100);
for i = 1:100
    best = JADE(D, 25, n, -2, 2, 25, rankTest);
    evaluation(:,i) = best;
    progressBar(30,i,100,true,true,true);
end

rstd = std(evaluation,1,2)
rmean = mean(evaluation,2)
rmin = [min(evaluation(1,:)); min(evaluation(2,:))]
rmax = [max(evaluation(1,:)); max(evaluation(2,:))]
