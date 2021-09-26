% returns [fib(n+1) fib(n) ]' using the matrix formula 
function f = fib_maxtrix(n)

r5 = 5^0.5;
V = [ 1 1 ; (r5-1)/2 (-r5-1)/2];
invV = [ (5+r5)/10 r5/5 ; (5-r5)/10 -r5/5];
Dn = [ (1+r5)/2 0 ; 0 (1-r5)/2 ]^n;

f= V*Dn*invV*[1 1]';

end%func