function [Q, R] = DecomposicaoQR(A)
% [Q, R] = DecomposicaoQR(A) realiza decomposicao QR na matriz A de modo
% que A = Q * R, em que Q eh ortogonal e R eh triangular superior.
% Para realizar a decomposicao, a funcao usa rotacoes de Givens.

n = size(A,1);

Q = eye(size(A));
R = A;

for j = 1:n-1
    for i = n:-1:1+j
        if R(i, j) == 0
            continue;
        end
        
        h = sqrt(R(i-1:i,j)'*R(i-1:i,j));
        if h == 0
            continue;
        end
        U = [R(i-1, j), R(i, j); -R(i, j), R(i-1, j)];        
        
        R(i-1:i, j:end) = (U *R(i-1:i, j:end))/h;
        Q(i-j:end, i-1:i) = (Q(i-j:end, i-1:i)*U')/h;
    end
end


end
