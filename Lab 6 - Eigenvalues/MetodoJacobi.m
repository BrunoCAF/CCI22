function [V, D] = MetodoJacobi(A, epsilon, maxIteracoes)
% [V, D] = MetodoJacobi(A, epsilon, maxIteracoes) determina todos os
% autovalores e autovetores da matriz simetrica A, usando epsilon como
% tolerancia sobre os elementos fora da diagonal principal e
% maxIteracoes como numero maximo de iteracoes. Caso epsilon ou
% maxIteracoes nao sejam fornecidos, a funcao usa epsilon = 10^-3 e 
% maxIteracoes = 10000. Os retornos da funcao sao a matriz dos autovetores
% normalizados V e uma matriz diagonal D com os autovalores.

if nargin < 2
    epsilon = 10^-3;
end
if nargin < 3
    maxIteracoes = 10000;
end

D = A;
V = eye(size(A));

[v, p, q] = MaiorValorForaDaDiagonal(D);
if v < epsilon
    numIteracoes = maxIteracoes;
else
    numIteracoes = 0;
end

while numIteracoes < maxIteracoes
    %Ja tenho p, q
    %Constroi U a partir de p, q
    U = CalculaU(D, p, q);
    
    %Atualiza V e D
    V = V*U';
    D = U*D*U';
    
    %Pegando o elemento fora da diagonal principal
    [v, p, q] = MaiorValorForaDaDiagonal(D);
    
    numIteracoes = numIteracoes + 1;
    if v < epsilon
        numIteracoes = maxIteracoes;
    end
end

end

function U = CalculaU(D, p, q)

phi = (D(q, q) - D(p, p))/(D(p, q) + D(q, p));
if phi == 0
    t = 1;
else
    t = 1/(phi + sign(phi)*sqrt(1 + phi^2));
end
c = 1/sqrt(1+t^2); s = t*c;

U = eye(size(D));
U(p, p) = c; U(q, q) = c;
U(p, q) = -s; U(q, p) = s;

end

function [v, p, q] = MaiorValorForaDaDiagonal(A)

%Pegando o elemento fora da diagonal principal:
[V, I] = max( abs( A - diag(diag(A)) ) );
[v, J] = max(V);
p = I(J); q = J;
%|A(p, q)| = v eh o maior elemento (em abs) fora da diagonal principal
%Se v < epsilon, para o algoritmo. 

end