function [A,b] = genSpSassenfeldOk(n,mdense,diagmult)
% generate a Sparse n x n matrix which satisfies Sassenfeld
%
% a simmetric positive definite matrix satisfies Sassenfeld, 
% therefore it actually generates a random simmetric matrix, and then
% augments (pretty much) the diagonal. with good parameters, it is not
% necessary to test Sassenfeld, but we test it to make sure
%
% you can generate large matrices! 
%
%http://math.stackexchange.com/questions/357980/how-to-generate-random-symmetric-positive-definite-matrices-using-matlab
% sassenfeld is satisfied if A is positive definite
% https://en.wikipedia.org/wiki/Gauss%E2%80%93Seidel_method#Convergence
if nargin < 2
    mdense = 0.01;
end
if nargin < 2
    diagmult = 0.3;
end


A = sprand(n,n,mdense);
b = rand(n,1);
while ( ~gCriterioSassenfeld(A) || condest(A,2) > 1000)
    A = sprand(n,n,mdense);
    if (n > 4)% for small matrices we do not need to worry. 
        A = 0.5*(A+A'); % simetric 
        A = A + diagmult*n*eye(n); % large diagonal
    end
end

end%func
