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

runs = 150;
fn = 4;

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
rows = cell(1, fn*D);
k = 1;
for i = 1:fn
   for j = 1:D
       rows{k} = ['Func ' num2str(i) ', Dim ' num2str(j)];
       k = k + 1;
   end
end
T = table(StandardDeviation, Mean, 'RowNames', rows)

% [(1:fn*D)' rstd rmean]

% rstd = zeros(1,fn);
% rmean = zeros(1,fn);
% a = 1:D:(D*fn);
% b = D:D:(D*fn);
% for i = 1:fn
%     rstd(i) = std2(results(a(i):b(i),:));
%     rmean(i) = mean2(results(a(i):b(i),:));
% end

% [StandardDeviation; Mean]

% figure(1);
% plot(rstd(1:30), 'b*')
% hold on;
% plot(rstd(31:60), 'g*')
% plot(rstd(61:90), 'r*')
% plot(rstd(91:120), 'c*')
% plot(rstd(121:150), 'm*')
% plot(rstd(151:180), 'k*')
% legend('2.0', '2.1', '2.2', '2.3', '2.4', '2.5');
% xlabel('Dimensão');
% ylabel('Desvio Padrão');
% 
% figure(2);
% plot(rmean(1:30), 'b*')
% hold on;
% plot(rmean(31:60), 'g*')
% plot(rmean(61:90), 'r*')
% plot(rmean(91:120), 'c*')
% plot(rmean(121:150), 'm*')
% plot(rmean(151:180), 'k*')
% legend('2.0', '2.1', '2.2', '2.3', '2.4', '2.5');
% xlabel('Dimensão');
% ylabel('Média');
                
load train
sound(y,Fs);

