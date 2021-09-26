function [D,QQ,niter] = eigenqr(A,maxiter)

if nargin < 2
    maxiter = 1000;
end

tol = 1e-10;

Q = eye(size(A));
R = A;

QQ = Q;
D = R;

niter = 0;

while niter < maxiter
    niter = niter + 1;
    [Q,R] = hqr(D);
    rD = max(max(abs(R*Q - D)));
    D = R*Q;
    QQ = QQ*Q;
    if rD < tol
        break;
    end
end

end