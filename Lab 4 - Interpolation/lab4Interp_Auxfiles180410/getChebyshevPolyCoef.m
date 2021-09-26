% return the coeficients of Tn in polyval format where:
% n : Tn is the nth chebyshev polinomial
% example
% getChebyshev(2)
% ans = 
%    2     0    -1
% because T2 is 2*x^2 - 1
% (it cheats and uses the symbolic toolbox to get the polynomial)
function p = getChebyshevPolyCoef(n)
syms x;
p = sym2poly(chebyshevT(n,x));
end