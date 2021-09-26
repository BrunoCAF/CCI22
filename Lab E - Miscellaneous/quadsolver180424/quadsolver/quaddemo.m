% quadric general form: Ax^2 + Bxy + Cy^2 + Dx + Ey + F = 0
q1 = [1 0 1 0 0 -1];
% circle
q2 = [1 1 0 0 0 -1];
% hyperbole
q3 = [0 0 -4 1 0  1];
% parabola
x0 = [-2; -1];  
% Make a starting guess at the solution
x0 = [0; .3];  
% Make a starting guess at the solution
% quadric general form: Ax^2 + Bxy + Cy^2 + Dx + Ey + F = 0
%q1 = circle2quad([-1,1],2);
%q2 = [1 0 0 -2 -1 2];
% parabola em x
%q3 = [0 0 1 -1 -2  2];
% parabola em y
%x0 = [2; 2];  
% Make a starting guess at the solution
% the countour plots are not needed.
% it is only to visualize the quadrics and jacobians are correct
% you may comment if you are confident your quadrics are ok
figure;
quadcontour(q1);

figure;
quadcontour(q2);

figure;
quadcontour(q3);

% you must complete mynonlinearsolver and use it here.
quadsolver(@mynonlinearsolver,q1,q2,q3,x0);
