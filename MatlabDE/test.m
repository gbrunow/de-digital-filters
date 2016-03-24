f = DigitalFilter(0.5*pi, 5);   %create a digital filter of 5th order with cutoff at 0.5*pi
f.setSamples(128)
f.lowpass;                     %set filter as a lowpass
% f.plot;                      %plot filter

% coefficients = [[1:12]', [2:2:24]'];
% eval = f.getEval;
% eval(coefficients);
% 
% D = 2;
% maxASize = 25;
% A = zeros(D, maxASize);
% archive = @(A, archiveSize, improvements) archiver(A, D, maxASize, archiveSize, improvements);
% A = archive(A, 0, ones(2,10));

maxB = 2;
minB = -2;
eval = f.getEval;
D = (f.order + 1) * 2;
pop = (maxB - minB) .* rand(D, NP) + minB;
eval(pop);
best = JADE(12, 75, 1500, -100, 100, 75, eval, 1);
f.b = best(1:6);
f.a = best(7:12);
f.plot
