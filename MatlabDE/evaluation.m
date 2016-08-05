D = 2;
n = 1000;
NP = 100;
minB = -2;
maxB = 2;
maxASize = NP;
F = 0.85;
CR = 0.25;

a = 1;
b = 10;
rosenbrock = @(pop) (a - pop(1,:)).^2 + b*(pop(2,:) - pop(1,:).^2).^2;

A = 10;
N = D;
rastrigin = @(pop) A*N + sum(pop.^2 - A*cos(2*pi*pop));

objFun = rosenbrock;
tic

runs = 100;
fn = 5;
funcNames = {'DE', 'JADE  ', 'SHADE ', 'LSHADE', 'LJADE '};

pmax = fn*runs*n;
results = zeros(fn * D, runs);

index = @(fni) (D*(fni-1)+1):(fni*D);
percentage = @(i,fni) ((i-1) + (fni/fn))/(fn*runs);

for i = 1:runs
    fni = 0;
    
    fni = fni + 1;
    best = DE(D, NP, n, minB, maxB, F, CR, objFun);
    results(index(fni),i) = best;
    progress(percentage(i,fni), 'Please wait...', false);
    
    fni = fni + 1;
    best = JADE(D, NP, n, minB, maxB, maxASize, objFun);
    results(index(fni),i) = best;
    progress(percentage(i,fni), 'Please wait...', false);
    
    fni = fni + 1;
    best = SHADE(D, NP, n, minB, maxB, maxASize, objFun);
    results(index(fni),i) = best;
    progress(percentage(i,fni), 'Please wait...', false);
    
    fni = fni + 1;
    best = LSHADE(D, NP, 4, n, minB, maxB, objFun);
    results(index(fni),i) = best;
    progress(percentage(i,fni), 'Please wait...', false);
    
    fni = fni + 1;
    best = LJADE(D, NP, 4, n, minB, maxB, objFun);
    results(index(fni),i) = best;
    progress(percentage(i,fni), 'Please wait...', false);
end
progress(1, 'Please wait...', false);

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

