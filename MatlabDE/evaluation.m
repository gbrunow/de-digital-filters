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

runs = 100;
fn = 2;

pmax = fn*runs*n;
pcurrent = 0;
results = zeros(fn * D, runs);
for i = 1:runs
    globalFeedback = @(g) progressBar(30,pcurrent+g,pmax,true,true,true,false);
    feedback = @(g) progressBar(30,g,n,false,false,true,true, globalFeedback);
    best = DE(D, NP, n, minB, maxB, objFun, feedback);
    results(1:D,i) = best;
    pcurrent = pcurrent + n;
    
    globalFeedback = @(g) progressBar(30,pcurrent+g,pmax,true,true,true,false);
    feedback = @(g) progressBar(30,g,n,false,false,true,true, globalFeedback);
    best = JADE(D, NP, n, minB, maxB, maxASize, objFun, feedback);
    results((D+1):(2*D),i) = best;
    pcurrent = pcurrent + n;
end

rstd = std(results,1,2);
rmean = mean(results,2);
[(1:fn*D)' rstd rmean]

rstd = zeros(1,fn);
rmean = zeros(1,fn);
a = 1:D:(D*fn);
b = D:D:(D*fn);
for i = 1:fn
    rstd(i) = std2(results(a(i):b(i),:));
    rmean(i) = mean2(results(a(i):b(i),:));
end

[rstd; rmean]

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
                
load handel
sound(y,Fs);

