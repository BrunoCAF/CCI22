clear all;
n = 5;
A = rand(n); A = A*A'*4;
disp('******* DEMO JACOBI ROTATION *************')
pr(A,'original matrix')

R1 = getJacobi(A,2,1);
pr(R1,'rotation to zero element 2,1');

A1 = R1' * A * R1;
pr(A1,'A1 = R1'' * A * R1 element 2,1 is zero!');

R2 = getJacobi(A1,3,1);
pr(R2,'rotation to zero element 3,1 of A1');

A2 = R2' * A1 * R2;
pr(A2,'R2'' * A1 * R2 element 3,1 of A1 is zero, but it A(2,1) is NOT zero anymore');



