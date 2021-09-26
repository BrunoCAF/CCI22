% inputs: 
% 2 quadrics, q1,q2
% xy 1x2 vector with a point coordinates [x y]
% outputs:
% fxy is F(x,y), as [q1(x,y),q2(x,y)]
% Jxy is Jacobian of F at (x,y), or J(x,y), as 2x2 matrix with
% [ dq1/dx(x,y) dq1/dy(x,y) ]
% [ dq2/dx(x,y) dq2/dy(x,y) ]
% 
function [fxy,Jxy] = F2(q1,q2,xy)

fxy(1) = fquad(xy(1),xy(2),q1);
fxy(2) = fquad(xy(1),xy(2),q2);
%fxy(3) = fquad(xy(1),xy(2),q3);

Jxy(1,:) = [ dfxquad(xy(1),xy(2),q1) dfyquad(xy(1),xy(2),q1) ];
Jxy(2,:) = [ dfxquad(xy(1),xy(2),q2) dfyquad(xy(1),xy(2),q2) ];
%Jxy(3,:) = [ dfxquad(xy(1),xy(2),q3) dfyquad(xy(1),xy(2),q3) ];

end%func