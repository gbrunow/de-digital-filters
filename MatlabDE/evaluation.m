D = 2;
n = 1000;
NP = 100;
minB = -2;
maxB = 2;
maxASize = NP;

a = 1;
b = 10;
rosenbrock = @(pop) (a - pop(1,:)).^2 + b*(pop(2,:) - pop(1,:).^2).^2;

A = 10;
N = D;
rastrigin = @(pop) A*N + sum(pop.^2 - A*cos(2*pi*pop));

objFun = rastrigin;
tic

runs = 51;
fn = 4;
funcNames = {'JADE  ', 'SHADE ', 'LSHADE', 'LJADE '};

pmax = fn*runs*n;
results = zeros(fn * D, runs);
for i = 1:runs
    best = JADE(D, NP, n, minB, maxB, maxASize, objFun);
    results(1:D,i) = best;
    progress((i-0.75)/runs, 'Please wait...', false);
    
    best = SHADE(D, NP, n, minB, maxB, maxASize, objFun);
    results((D+1):(2*D),i) = best;
    progress((i-0.5)/runs, 'Please wait...', false);
    
    best = LSHADE(D, NP, 4, n, minB, maxB, objFun);
    results((2*D+1):(3*D),i) = best;
    progress((i-0.25)/runs, 'Please wait...', false);
    
    best = LJADE(D, NP, 4, n, minB, maxB, objFun);
    results((3*D+1):(4*D),i) = best;
    progress(i/runs, 'Please wait...', false);
end

StandardDeviation = std(results,1,2);
Mean = mean(results,2);
Min = min(results, [], 2);
Max = max(results, [], 2);
rows = cell(1, fn*D);
k = 1;
Dimension = zeros(fn*D,1);
for i = 1:fn
   for j = 1:D
       if i <= length(funcNames)
        rows{k} = [funcNames{i} '  D' num2str(j)];
       else
        rows{k} = ['Func ' num2str(i)];
       end
       Dimension(k) = j;
       
       k = k + 1;
   end
end
T = table(StandardDeviation, Mean, Min, Max, 'RowNames', rows)
                
load train
sound(y,Fs);

