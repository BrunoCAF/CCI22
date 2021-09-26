% return the list of x coordinates of the chebyshev n+1 nodes for 
% interval [a , b] and number of nodes n
% it will contain the middle point only if n is odd
function x = chebyshev_nodes(a,b,n)
n = n - 1; % the formula must count the zero
i=[0:n]';
x = 0.5 * (a+b) + 0.5*(b-a)*cos(pi*(2*i+1)/(2*n+2));

end %func