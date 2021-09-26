function [satisfaz, beta] = CriterioSassenfeld(A)
% [satisfaz, beta] = CriterioSassenfeld(A) verifica se a matriz A satisfaz 
% o Criterio de Sassenfeld (condicao suficiente para convergencia do 
% Metodo de Gauss-Seidel) e retorna o resultado como a booleana
% satisfaz. Alem disso, o beta do Criterio de Sassenfeld eh retornado.

N = size(A, 1);

betas = zeros(N, 1);

% Implementar Criterio de Sassenfeld (calculo dos betas)

betas(1) = sum(abs(A(1,2:end)))/(abs(A(1,1)));
for j = 2:N
    betas(j) = (sum( abs(A(j,1:j-1)).*betas(1:j-1)' ) + sum(abs(A(j, j+1:end) ) ) )/(abs(A(j,j)));
end
beta = max(betas);

satisfaz = beta < 1;

end
