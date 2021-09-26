function [A,B] = calcAandBforTrilateration(x,y,b)

A = zeros(2,2);
B = zeros(2,1);

A(1,1) = sum(x.^2);
A(1,2) = sum(x.*y);
A(2,1) = sum(y.*x);
A(2,2) = sum(y.^2);
A = 2*A;

B(1) = sum(x.*b);
B(2) = sum(y.*b);
B = -B;

end