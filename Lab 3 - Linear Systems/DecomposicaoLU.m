function [L, U, P] = DecomposicaoLU(A)
% [L, U, P] = DecomposicaoLU(A) realiza Decomposicao LU com pivoteamento 
% parcial da matriz A e retorna as matrizes resultantes, em que L eh 
% triangular inferior, U eh triangular superior e P eh a matriz de 
% permutacoes devido ao pivoteamento parcial.

K = A;
P = eye(size(A,1));
L = zeros(size(A));

for i = 1:size(A,1)
    [~, I] = max(abs(K(i:end, i)));
    
    K = trocaL(K, i, I+i-1);
    P = trocaL(P, i, I+i-1);
    
    L = trocaL(L, i, I+i-1);
    
    [K, m] = exL(K, i, i);
    L(i+1:end, i) = m;
    
    
end

L = L + eye(size(L));
U = K(:, 1:end);
end

% troca linha l1 e l2 da matriz A
%A = trocaL(A,l1,l2)
function A = trocaL(A,l1,l2)
    aux = A(l1,:);
    A(l1,:) = A(l2,:);
    A(l2,:) = aux;
end

% troca uma linha da matriz pela combinacao linear de outra linha que a zera
% pode ser usado em resolucao de sistemas lineares
% lz: linhas com elementos a ser zerados. elas serao modificadas
%
%      se lz for omitido ou 'down', considera todas as linhas abaixo de lb
%      se lz for 'all', considera todas as linhas exceto lb, acima e abaixo
%      se lz for 'up', considera todas as linhas acima de lb
%
% lb: a linha base, que sera usada apenas para calcular m
% c : a coluna cujo elemento em lz deve ser zerado
%
% ou seja, as coordenadas do pivo sao (lb,c)
%
% A : a matriz
% 
% ****************** exemplos: ********************
% A = magic(4);
% A = exL(A,1,1,2)
% realiza o 1o passo da eliminacao de gauss, zerando o elemento A(2,1)
% usando A(1,1) como pivo
%
% A = magic(4);
% [A,m] = exL(A,1,1,'down') 
% [A,m] = exL(A,1,1,'all')
% [A,m] = exL(A,1,1,2:4)
% as tres formas sao apenas diferentes maneiras de indicar
% zera todos os elementos da coluna 1 da linha 2 ate a ultima coluna
%
% eliminacao ate uma matriz triangular
% A = rand(3,4);
% [A,m] = exL(A,1,1,'down') 
% [A,m] = exL(A,2,2,'down')
% 
% ou 
% 
% A = rand(3,4);
% [A,m] = exL(A,3,3,'up') 
% [A,m] = exL(A,2,2,'up')
%
% eliminacao ate diagonalizar o sistema
% A = rand(3,4);
% [A,m] = exL(A,1,1,'all') 
% [A,m] = exL(A,2,2,'all')
% [A,m] = exL(A,3,3,'all')
%
% m eh sempre uma matriz coluna com os multiplicadores
function [A,m] = exL(A,lb,c,lz)
    % option processing
    if (nargin < 4) 
        lz = 'down';
    end 
    if isequal(lz,'down')
        [lA,cA] = size(A);
        lz = lb+1:lA;
    elseif (isequal(lz,'all'))
        [lA,cA] = size(A);
        lz = [1:lb-1 lb+1:lA];
    elseif (isequal(lz,'up'))
        [lA,cA] = size(A);
        lz = [1:lb-1];
    end
    % expected: lz contains the collumn indexes to be changed
    
    % all actual work is done here
    m = A(lz,c)/A(lb,c);
    A(lz,:) = A(lz,:) - m * A(lb,:);
end
