clear all;
n = 5; I = eye(n);
A = rand(n); A = A*A'*4; % random, real, symetric

[tau,w]=diagheiseholder(A,1);% H to clear 1st collumn
H1 = I-tau*w*w';

H1A = H1 * A ;
AH1 =  A * H1;
H1AH1 = H1 * A * H1 ;

pr(A,'********** input matrix ******** ')
pr(H1,'1st householder reflexion in matrix form')
%%% showing H1 == H1'' == inv(H1) )
err1 = max(max(abs(H1-H1')));
err2 = max(max(abs(H1-inv(H1))));
err3 = max(max(abs(H1*H1-eye(n))));
err = max([err1 err2 err3]);
disp(sprintf('showing H1 == H1'' == inv(H1), and H1 is orthogonal: err = %g \n',err));

pr(H1A,'H1 * A  clears first line below diagonal')
pr(AH1,'A * H1 clears first collumn after diagonal')
pr(H1AH1,'but H1 * A * H1 does not clear both line and collumn')