% inputs: 
% n quadrics, q1,q2...qn
% xy 1x2 vector with a point coordinates [x y]
% THE LAST ARGUMENT MUST BE xy 
%
% outputs:
% fxy is F(x,y), as [q1(x,y),q2(x,y),...,qn(x,y)]
% Jxy is Jacobian of F at (x,y), or J(x,y), as nxn matrix with
% [ dq1/dx(x,y) dq1/dy(x,y) ]
% [ dq2/dx(x,y) dq2/dy(x,y) ]
% [     ...        ...      ]
% [ dqn/dx(x,y) dqn/dy(x,y) ]
% 
function [fxy,Jxy] = F(varargin)
xy = varargin{end};

for i = 1:(nargin-1)
    fxy(i) = fquad(xy(1),xy(2),varargin{i});
    %fxy(2) = fquad(xy(1),xy(2),q2);
    %fxy(3) = fquad(xy(1),xy(2),q3);

    Jxy(i,:) = [ dfxquad(xy(1),xy(2),varargin{i}) dfyquad(xy(1),xy(2),varargin{i}) ];
    %Jxy(2,:) = [ dfxquad(xy(1),xy(2),q2) dfyquad(xy(1),xy(2),q2) ];
    %Jxy(3,:) = [ dfxquad(xy(1),xy(2),q3) dfyquad(xy(1),xy(2),q3) ];
end%for

end%func