% returns the values of the quadric q in the coordinates x and y
% x and y may be scalars or collumn vectors
% in the latter case, will return collumn vector fo the same size, with
% the quadric values on the coordinates of each line of input
function values = fquad(x,y,q)
%Ax^2 + Bxy + Cy^2 + Dx + Ey + F = 0

% computes matrix with lines [ x^2  xy y^2  x  y  1 ]
quaddef = [x.^2 x.*y  y.^2  x  y ones(length(x),1)]; % size n x 6
% multiplies by quadric coeficients as column vector
values = quaddef * [q(1); q(2); q(3); q(4); q(5); q(6); ];
end