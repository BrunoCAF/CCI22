function [A,b] = generateSassenfeldOk(n)
%http://math.stackexchange.com/questions/357980/how-to-generate-random-symmetric-positive-definite-matrices-using-matlab
% sassenfeld is satisfied if A is positive definite
% http://math.stackexchange.com/questions/357980/how-to-generate-random-symmetric-positive-definite-matrices-using-matlab
% sassenfeld is satisfied if A is positive definite
% https://en.wikipedia.org/wiki/Gauss%E2%80%93Seidel_method#Convergence
A = rand(n);
b = rand(n,1);
while ( ~gCriterioSassenfeld(A) || cond(A) > 1000 )
    A = rand(n);
    if (n > 4)
        A = 0.5*(A+A'); 
        A = A + 0.5*n*eye(n);
    end
end

end%func
