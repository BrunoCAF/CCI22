q1 = [1 0 1 0 0 -4];
q2 = [0.25 0 0 0 1 -2.0000000001];
x0 = [0.3;1.8];

quadsolver(@mynonlinearsolver, q1, q2, x0, 1)

q1 = [1 1 -1 0 0 -3];
q2 = [0 0 2 -1 1 1];
x0 = [1;0];

quadsolver(@mynonlinearsolver, q1, q2, x0, 2)


function quadsolver(yoursolver,q1,q2,x0, file) 

% plot each quadric
figure; 
hold on; 
grid on;

quad2dplot(q1,'b');
quad2dplot(q2,'r');

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

legend({quad2str(q1), quad2str(q2), 'intermediate solutions', 'final solution', 'initial guess', 'fsolve solution'}, 'FontSize',10, 'Location','southwest')

if file == 1
    print -dpng -r400 conicas1.png;
elseif file == 2
    print -dpng -r400 conicas2.png;
end

end
%func