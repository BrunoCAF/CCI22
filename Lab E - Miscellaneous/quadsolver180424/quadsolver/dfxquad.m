% returns the values of the x derivative of quadric q in the coordinates x and y
% x and y may be scalars or collumn vectors
% in the latter case, will return collumn vector fo the same size, with
% the quadric values on the coordinates of each line of input
function values = dfxquad(x,y,q)
%quad  => Ax^2 + Bxy + Cy^2 + Dx + Ey + F = 0
%df/dx => 2*Ax + By         + D  +    +   = 0

% computes matrix with lines [ 2*x  y   1 ]
quaddef = [ 2.*x  y  ones(length(x),1)]; % size n x 3
% multiplies by quadric coeficients as column vector 
values = quaddef * [q(1); q(2); q(4) ]; % (n x 3) * (3 x 1) = n x 1  
end