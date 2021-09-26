function T = AlgoritmoQR(A, epsilon, maxIteracoes)
% T = AlgoritmoQR(A, epsilon, maxIteracoes) realiza o algoritmo QR 
% para determinacao de autovalores da matriz quadrada A, 
% utilizando epsilon como tolerancia para os elementos abaixo da
% diagonal principal e maxIteracoes como numero maximo de iteracoes. Caso 
% epsilon ou maxIteracoes nao sejam fornecidos, a funcao usa 
% epsilon = 10^-3 e maxIteracoes = 10000. O retorno da funcao eh a 
% matriz triangular superior T, resultante do algoritmo QR e que 
% possui os autovalores na diagonal principal.

if nargin < 2
    epsilon = 10^-3;
end
if nargin < 3
    maxIteracoes = 10000;
end

T = A;

v = max(max(abs(tril(T) - diag(diag(T)))));
if v < epsilon
    numIteracoes = maxIteracoes;
else
    numIteracoes = 0;
end

while numIteracoes < maxIteracoes
    [Q, R] = DecomposicaoQR(T);
    T = R*Q;
    
    v = max(max(abs(tril(T) - diag(diag(T)))));
    numIteracoes = numIteracoes + 1;
    if v < epsilon
        numIteracoes = maxIteracoes;
    end
    
end


end
