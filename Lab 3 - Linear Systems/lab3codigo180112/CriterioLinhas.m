function satisfaz = CriterioLinhas(A)
% satisfaz = CriterioLinhas(A) verifica se a matriz A satisfaz o Criterio 
% das Linhas (condicao suficiente para convergencia do Metodo de
% Gauss-Jacobi) e retorna o resultado como a booleana
% satisfaz.

N = (sum(abs((A(:,:)'))) < (diag(abs(2*A)))');
satisfaz = min(N);

% Implementar Criterio das Linhas

end
