%draws contour plot of quadric with the respective jacobian vectors.
function quadcontour(q)

hold on; 
grid on;
ezcontour(@(x,y) fquad(x,y,q));

axis equal;
title(quad2str(q));

plotinterval = -2*pi:pi/4:2*pi;
[x,y] = meshgrid(plotinterval,plotinterval);
x = reshape(x,[],1); 
% transform x and y in collumn vectors
y = reshape(y,[],1);
quiver(x,y,dfxquad(x,y,q),dfyquad(x,y,q) );

end
%func