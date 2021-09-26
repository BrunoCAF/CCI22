function [p, cA] = PolinomioInterpolador(x, y, maxCond)
% p = PolinomioInterpolador(x, y) determina o polinômio interpolador 
% p_n(x) a partir de n + 1 pontos de interpolação, definidos pelos vetores
% coluna x = [x_0,x_1,...,x_n]' e y = [f(x_0),f(x_1),...,f(x_n)]'. O vetor 
% linha p é escrito na seguinte forma:
% p = [ a_n   a_{n-1}   a_{n-2}   ...   a_0 ]
% De modo a representar um polinÃ´mio interpolador p_n(x) \) na forma:
% p_n(x) = a_n * x^n + a_{n-1} * x^{n-1} + a_{n-2} * x^{n-2} + ... + a_0
% Note que este formato de p é coerente com o esperado pela função 
% polyval.
%
% cA retorna cond(A) onde A eh a matriz de coefiecientes do sistema
% linear. 
%
% maxCond: max limit for cond(A). if the coeficient matrix is badly
% conditioned, reject it and do not calculate p. p will be empty.
% default, if maxCond is not given, always calculate p even if broken

if (nargin < 3)
    maxCond = 1e20;
end

% Montar matriz A de verdade
N = length(x) - 1;
A = x.^(0:N);

% usa esta parte para nao tentar resolver o sistema
% se for muito mal condicionado
cA = cond(A); 
if (cA > maxCond)
    p = []; 
    return; % nao tenta resolver
end
% se esta aqui, A eh bem condicionada

p = fliplr(linsolve(A, y)'); 

end%function
