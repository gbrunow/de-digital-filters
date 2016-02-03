% This script finds the amplitude complementary IIR filter.
% 1st IIR filter is designed using matlab function 2nd IIR filter is found
% by using error minimization using fminsearch matlab function.

format long g;
Fs                    = 44100;       % sampling frequency of the underlying signal in Hz
freqPoints            = 1024;

% Design maximally flat Lowpass filter using matlab command
N                     = 4;         % order of the filter
Fc                    = 10000;        % cut off frequency in Hz
[b,a,b1,b2,sos_var,g] = maxflat(N,N,Fc/(Fs/2));
%[b,a,b1,b2,sos_var,g]= maxflat(N, Fc/(Fs/2));
Hd                    = dfilt.df2sos(sos_var, g);
[b, a]                = tf(Hd);      % b:numerator coefficient, a:denominator coefficient

% Design Magnitude Complementary filter using fminsearch matlab command

% put num and den in a single input vector for Lowpass filter
coeffLow              = [b,a];       

% intitlize 2nd (Highpass)filter with reversed and randomized 1st filter's coefficients.
coeffHigh             = [-b(end:-1:1)+0.01*rand(1,length(b)),-a(end:-1:1)+0.01*rand(1,length(a))];

% find 2nd filter's coefficients such that  filer coeffHigh and coeffLow minimises a cost function.
[coeffHigh, fval, exitflag] = fminsearch(@(coeffHigh)costFunctionIIR(coeffLow,coeffHigh,freqPoints), coeffHigh);

% run some iterations...
for i=1:5,
    t=coeffHigh;
    %[y,fval, exitflag] = fminsearch(@(y)costFunctionIIR(b,y,freqPoints), x);
    [coeffHigh, fval, exitflag] = fminsearch(@(coeffHigh)costFunctionIIR(coeffLow,coeffHigh,freqPoints), t);
end

% Testing the results.
w=linspace(1,Fs/2,freqPoints)';
m0=(abs(freqz(coeffLow(1:end/2),coeffLow(end/2+1:end),freqPoints))); % 1st filter magnitude response
m1=(abs(freqz(coeffHigh(1:end/2),coeffHigh(end/2+1:end),freqPoints))); % 2nd filter magnitude response
plot(w,m0);hold on;  % plot 1st filter
plot(w,m1,'r'); % plot 2nd filter
plot(w,m0.*m0 + m1.*m1,'g'); % plot summed responce
hold off
beep;beep % signal after comlpetion.