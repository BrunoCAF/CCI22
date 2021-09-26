function x = SolucaoTriangularSuperior(A, b)
% x = SolucaoTriangularSuperior(A, b) resolve um sistema linear de equacoes
% A * x = b em que a matriz A eh triangular superior e retorna a solucao x.
x = zeros(size(b));

for i = size(b,1):-1:1
    x(i) = (b(i) - sum( A(i, i+1:end).*(x(i+1:end))' ))/A(i,i);
end

end