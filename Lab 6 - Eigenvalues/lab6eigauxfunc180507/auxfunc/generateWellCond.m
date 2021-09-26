% generates a random well conditioned matrix of size n x n
% optionally, if f is supplied, it applies A=f(A) before checking if it is
% well conditioned.
% if fcond is supplied, it also checks if fcond(A) is true.
% example: generateWellCond(n,@triu) generates a well conditioned upper
% triangular matrix 
function [A,b] = generateWellCond(n,f,fcond)
if nargin < 2 || isempty(f)
   f = @(x) x; % identity
end
if nargin < 3 || isempty(fcond)
   fcond = @(x) 1; %always true 
end

A = rand(n);
A = f(A);
b = rand(n,1);

while (cond(A)>1000) || (~fcond(A))
    A = rand(n);
    A = f(A);
end

end%func