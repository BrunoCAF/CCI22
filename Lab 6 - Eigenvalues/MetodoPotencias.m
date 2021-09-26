function [v, lambda] = MetodoPotencias(A, x0, epsilon, maxIteracoes)
% [v, lambda] = MetodoPotencias(A, x0, epsilon, maxIteracoes) determina o 
% maior autovalor lambda da matriz A e seu autovetor normalizado associado
% v, usando x0 como chute inicial, epsilon como tolerancia relativa e 
% maxIteracoes como numero maximo de iteracoes. Caso x0, epsilon ou 
% maxIteracoes nao sejam fornecidos, a funcao considera 
% x0 = [1, 1,..., 1]^T, epsilon = 10^-3 e maxIteracoes = 10000.

N = size(A, 1);

if nargin < 2
    x0 = ones(N, 1);
end
if nargin < 3
    epsilon = 10^-3;
end
if nargin < 4
    maxIteracoes = 10000;
end

lambda = 1;
numIteracoes = 1;
v = x0./norm(x0);
while numIteracoes < maxIteracoes
    
    b = A*v; b = b./norm(b);
    rv = max(abs(b - v)) / max(abs(b));
    v = b;
    
    rayleigh_quotient = (v'*A*v)/(v'*v);
    rlambda = abs(1 - lambda/rayleigh_quotient);
    lambda = rayleigh_quotient;
    
    numIteracoes = numIteracoes + 1;
    if rv < epsilon && rlambda < epsilon
        numIteracoes = maxIteracoes;
    end
end

end
