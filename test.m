% clear all;
close all;
clc;

func = @highpass;
type = 'iir';
cutoff = [ 0.5 ];
samples = 128;
freq = [0 pi];
F = 0.85;
CR = 0.25;

% filter = SADE(12, 75, 1500, -100, 100, @evalFilters, {func, cutoff, {type, freq, samples}});
filter = JADE(12, 75, 1500, -100, 100, @evalFilters, {func, cutoff, {type, freq, samples}});
% filter = DE(12,75,1500, F, CR, -100, 100, @evalFilters, {func, cutoff, {type, freq, samples}});
info = evalFilters(filter, {func, cutoff, {type, freq, 4096}, true});
plotBestFilter(info, true);
% b = filter(1 : end/2);
% a = filter(end/2 + 1 : end);
% [h, w] = freqz(b,a);
% [h, w] = freqz(b,a, 2048, 'whole');