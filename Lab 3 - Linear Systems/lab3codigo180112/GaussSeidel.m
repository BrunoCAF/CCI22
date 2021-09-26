function [x, dr] = GaussSeidel(A, b, x0, epsilon, maxIteracoes)
% [x, dr] = GaussSeidel(A, b, x0, epsilon, maxIteracoes) resolve o sistema
% A * x = b atraves do Metodo de Gauss-Seidel, usando x0 como chute 
% inicial, epsilon como tolerancia para criterio de parada por erro
% relativo e maxIteracoes como limite maximo de iteracoes. A solucao x eh
% retornada, juntamente com o vetor dr, que contem os erros relativos de
% todas as iteracoes, de modo que dr(k) eh o erro relativo calculado na 
% iteracao k.
%
% Os seguintes valores padrao sao usados para os 3 ultimos parametros caso
% algum deles nao seja definido: 
% x0 = [0 ... 0]^T (vetor nulo de mesma dimensao que o vetor b)
% epsilon = 10^-10
% maxIteracoes = 10^6

% x0 nao foi definido
if nargin < 3
    x0 = zeros(size(A, 1), 1);
end

% epsilon n�o foi definido
if nargin < 4
    epsilon = 10^-10;
end

% maxIteracoes nao foi definido
if nargin < 5
    maxIteracoes = 10^6;
end

N = size(A, 1);
C = eye(N) - A./diag(A);
g = b./diag(A);

x = x0;
k = 1;
d = 0;
dr = zeros(maxIteracoes, 1);
dr(1) = epsilon;

while k < maxIteracoes
    y = x;
    
    for i = 1:N
        x(i) = C(i,1:end)*x + g(i);
    end
    
    d = max(abs( x - y ));
    
    dr(k) = d/(max(abs(x)));
    if dr(k) < epsilon
        break;
    end
    k = k+1;
end

dr = dr(1:k);
% Implementar Metodo de Gauss-Seidel

end
