function x = SolucaoTriangularInferior(A, b)
% x = SolucaoTriangularInferior(A, b) resolve um sistema linear de equacoes 
% A * x = b em que a matriz A eh triangular inferior e retorna a solucao x.
x = zeros(size(b));

x(1) = b(1)/A(1,1);

for i = 2:size(b,1)
    x(i) = (b(i) - sum( A(i, 1:i-1).*(x(1:i-1))' ))/A(i,i);
end

end

