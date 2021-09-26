% q is quadric
% qcolor is color (NOT includes LineShape)
function [h] = quad2dplot(q,qcolor,useCurrentLimits)
if (nargin < 2)
    qcolor = [0 1 0];
end
if (nargin < 3)
    useCurrentLimits=0;
end
if (useCurrentLimits <= 0)
    h=ezplot( @(x,y) fquad(x,y,q) );
else
    xl = xlim();
    yl = ylim();
    h=ezplot( @(x,y) fquad(x,y,q) ,[xl yl]);
end
set(h,'color',qcolor);
set(h,'LineWidth',2);
axis equal; %equal scales on x and y axes.
end%func