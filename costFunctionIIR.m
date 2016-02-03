function f = costFunctionIIR(coeff1, coeff2, freqPoints)
% f = costFunction(Num1, Num2, freqPoints)
%
% This function takes IIR filters coefficients and number of 
% frequency points as arguments and calculates  error between 
% the filters responces.
%
% Input parameters:
%     Num1        1st IIR filter's coefficients
%     Num2        2nd IIR filter's coefficients
%     freqPoints  number of frequancy points
%
% Output parameters:
%      f          error between frequency responce

Num1 = coeff1(1:end/2);
Den1 = coeff1(end/2+1:end);
Num2 = coeff2(1:end/2);
Den2 = coeff2(end/2+1:end);
H1 = freqz(Num1,Den1,freqPoints);
H1Conj = conj(H1);
H2 = freqz(Num2,Den2,freqPoints);
H2Conj = conj(H2);
Temp = (H1.*H1Conj + H2.*H2Conj - 1.0);
f = sum(abs(Temp));