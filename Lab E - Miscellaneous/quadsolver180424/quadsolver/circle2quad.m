function q = circle2quad(c,r)
% given center [Cx,Cy] and radius r of a circle, get its corresponding
% quadric in general format.
% here is the proof (Cx, Cy) are the center coordinates
% (x - Cx)^2 + (y - Cy)^2 - r^2 = 0;
% x^2 -2xCx + Cx^2 + y^2 - 2yCy + Cy^2 + - r^2 = 0
% x^2 + 0xy + y^2 - 2Cx*x - 2Cy*y +Cx^2+Cy^2-r^2 = 0

q = [ 1 0 1  -2*c(1) -2*c(2) c(1)^2+c(2)^2-(r^2)];

%quad2dplot(q);
%grid on;
end