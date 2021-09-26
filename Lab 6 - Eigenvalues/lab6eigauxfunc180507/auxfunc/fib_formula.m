% calculates fibonacci series.
% fib_formula(n)  returns the nth fibonacci number if n scalar
% fib_formula(v)  if v is a vector, returns a vector of fibonacci numbers,
%                 for each element of v
% e.g: 
% >> fib_formula(6)
% 6
% 
% >> fib_formula(1:10)
%  1.0000    1.0000    2.0000    3.0000    5.0000    8.0000 
%  13.0000   21.0000   34.0000   55.0000
%
function f = fib_formula(n)

r5 = 5^0.5;

% note the .^ operator instead of just ^ it works with vector n instead of
% just scalar n
f = (1/r5) * ( ((1+r5)/2).^n - ((1-r5)/2).^n ); 

end%func