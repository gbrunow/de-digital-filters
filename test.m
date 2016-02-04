clear all;
close all;
clc;

filter = JADE(12,250,3000,-10,10, @evalFilter, { @lowpass, 'iir', [0.5], 512, false });
evalFilter(filter, {@lowpass, 'iir', [0.5], 2048, true})