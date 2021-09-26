clear all; 
A = rand(5); A = (A * A')*0.5; 
[v,d] = eig(A);
eigA = diag(d)';% the eigenvalues


% matriz example on wikipedia
%A = [ 4 1 -2 2 ; 1 2 0 1 ;-2 0 3 -2 ; 2 1 -2 -1 ];
disp('********** demo eigenvalues using householder and jacobi **********')
pr(A,'original matrix');

[M,PP,allA,allP] = householderTridiagonalization(A);

[D,RR,niter_jacobi] = cyclejacobi(M);

autovalue_error = (sort(eigA) - sort(diag(D)'));
pr(M,'tridiagonal matrix after householder',1e-16);
pr(D,'diagonal matrix, similar to A',1e-16);
pr(autovalue_error,'difference between eig(A) and elements of D (sorted)');
pr(eigA);

disp(['--- show n. iter and that it is really a decomposition ---' char(10)]) ;
decompAfromM = PP * M * PP';
max_errorA_from_M = max(max(abs(decompAfromM - A)));

decompAfromD = PP * RR * D * RR' * PP';
max_errorA_from_D = max(max(abs(decompAfromD - A)));

%check autovectors.
PPRR = PP*RR;
max_error_eigenvectors = compEigenVectors(v,PPRR);

disp(table(niter_jacobi,max_errorA_from_M,max_errorA_from_D,max_error_eigenvectors))
