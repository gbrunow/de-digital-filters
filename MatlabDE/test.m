f = DigitalFilter(0.5*pi, 5);   %create a digital filter of 5th order with cutoff at 0.5*pi
f.setSamples(512);
f.highpass;                     %set filter as a lowpass

eval = f.getEval;
D = (f.order + 1) * 2;
n = 1000;
NP = 75;
maxASize = NP;
tic
% feedback = @(g) progressBar(30,g,n,true,false,true,true);
best = SHADE(D, NP, n, -100, 100, maxASize, eval, @progress);
% best = JADE(D, NP, n, -100, 100, maxASize, eval, @progress);
% best = DE(D, NP, n, -100, 100, eval, @progress);
f.b = best(1:(D/2));
f.a = best((D/2 +1):end);
f.plot
shg;