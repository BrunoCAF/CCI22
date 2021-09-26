function [x, lambda, niter] = invpowereig(A, maxiter)
if nargin < 2
    maxiter = 100;
end

tol = 1e-6;

x = ones(size(A,1), 1);
lambda = 1;
niter = 0;
while niter < maxiter
    niter = niter + 1;
    b = (A-eye(size(A)).*lambda)\x;
    rx = max(abs(b./norm(b) - x));
    x = b./norm(b);
    rlambda = abs((x'*A*x)/(x'*x) - lambda);
    lambda = (x'*A*x)/(x'*x);
    if rx < tol && rlambda < tol
        break;
    end
end

end