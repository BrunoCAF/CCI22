function quadsolver(yoursolver,q1,q2,q3,x0) 

% plot each quadric
figure; 
hold on; 
grid on;

quad2dplot(q1,'g');
quad2dplot(q2,'b');
quad2dplot(q3,'r');

% solve non-linear equations, find intersection point of the 3 quadrics

options = optimoptions('fsolve','Display','iter','Jacobian','on'); 
% Option to display output and use jacobians

%[x,fval,exitflag,output,jacobian] = fsolve(@(x) F(q1,q2,q3,x),x0,options)
%[mysol] = yoursolver(@(x) F(q1,q2,q3,x),x0);

[x,fval,exitflag,output,jacobian] = fsolve(@(x) F(q1,q2,x),x0,options);
[mysol] = yoursolver(@(x) F(q1,q2,x),x0);

%plot your solution with intermediate solutions
plot(mysol(:,1),mysol(:,2),'+k-','MarkerSize',10,'LineWidth',2);
plot(mysol(end,1),mysol(end,2),'*k','MarkerSize',10,'LineWidth',2);

% plots the start and intersection point
plot(x0(1),x0(2),'om','MarkerSize',10,'LineWidth',2);
plot(x(1),x(2),'xm','MarkerSize',10,'LineWidth',2);

legend({quad2str(q1), quad2str(q2), quad2str(q3), 'intermediate solutions', 'final solution', 'initial guess', 'fsolve solution'}, 'FontSize',14)

end
%func