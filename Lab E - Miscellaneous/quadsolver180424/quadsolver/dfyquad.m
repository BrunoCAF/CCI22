% returns the values of the x derivative of quadric q in the coordinates x and y
% x and y may be scalars or collumn vectors
% in the latter case, will return collumn vector fo the same size, with
% the quadric values on the coordinates of each line of input
function values = fquad(x,y,q)
%quad  => Ax^2 + Bxy + Cy^2 + Dx + Ey + F = 0
%df/dy =>      + By  + 2*Cy +    + E  +   = 0
% computes matrix with lines [ y  2*y  1 ]
quaddef = [ y  2.*y  ones(length(x),1)]; % size n x 6
% multiplies by quadric coeficients as column vector
values = quaddef * [q(2); q(3); q(5) ];
end