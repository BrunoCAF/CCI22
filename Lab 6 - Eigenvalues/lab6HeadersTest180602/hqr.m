function [Q,R] = hqr(A)

H = eye(size(A));
Q = H;

for k = 1:size(A,1)
    H = eye(size(A));
    R = Q*A;
    [t, v] = diagheiseholder(R,k);
    H(k:end,k:end) = eye(size(A,1)-k+1) - t*(v*v');
    Q = H*Q;
end

R = Q*A;
Q = Q';


end