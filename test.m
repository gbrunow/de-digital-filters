% clear all;
close all;
clc;

func = @highpass;
type = 'iir';
cutoff = [ 0.5 ];
samples = 128;
freq = [0 pi];

filter = JADE(12,75,1500, -pi, pi, @evalFilters, {func, cutoff, {type, freq, samples}});
info = evalFilters(filter, {func, cutoff, {type, freq, 2048}, true});
plotBestFilter(info);
% b = filter(1 : end/2);
% a = filter(end/2 + 1 : end);
% [h, w] = freqz(b,a);
% [h, w] = freqz(b,a, 2048, 'whole');