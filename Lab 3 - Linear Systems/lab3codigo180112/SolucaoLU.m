function x = SolucaoLU(L, U, P, b)
% x = SolucaoLU(L, U, P, b) soluciona o sistema linear de equacoes 
% L * U = P * b atraves da solucao sucessiva dos sistemas L * y = P * b e 
% U * x = y. L * U = P * b eh o sistema resultante da Decomposicao LU com 
% pivoteamento parcial aplicada a um sistema A * x = b. O retorno da 
% funcao eh a solucao x.
y = SolucaoTriangularInferior(L, P*b);
x = SolucaoTriangularSuperior(U, y);
end