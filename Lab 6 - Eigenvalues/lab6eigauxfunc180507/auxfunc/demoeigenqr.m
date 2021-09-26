clear all;
n = 4; % the size of input
A = rand(n);
%**********************************************
A = A*A'*0.5; % TRY: comment this line, so A is not simmetric anymore.
%**********************************************

[v,l] = eig(A);
eigA = sort(diag(l)');

[D,QQ,niter] = geigenqr(A,1000);

d = sort(diag(D)');

max_err_eigenvalues = max(abs(d-eigA));
disp('******** DEMO FINDING EIGENVALUES VIA ITERATIVE QR METHOD ********')
pr(A,'input matrix')
pr(eigA,'its eigenvalues from eig()')
pr(d,'diag(D), its eigenvalues from eigenqr')
pr(v,'its eigenvectors from eigenqr')

pr(D,'diagonalized matrix',1e-16)
pr(QQ,'the transform matrix',1e-16)

% show that A is really decomposed 
recoverA = QQ*D*QQ';
max_err_recoverA = max(max(abs(recoverA-A)));

[max_err_eigenvectors] = compEigenVectors(v,QQ);
disp('--- show it is really a decomposition and eigenvectors/values are correct ----')
disp(table(niter,max_err_eigenvalues,max_err_eigenvectors,max_err_recoverA));

% show that QQ is really orthogonal
disp(sprintf('check if QQ is orthogonal: error =  %.7g \n',orthogonalError(QQ)))

disp('********** question ********** ');
disp('try with A real and symmetric. what are D and QQ?');
disp('are eigenvectors/values at the same order? with the same signal?');
disp('if not, then how are they compared in compEigenVectors()?');
disp('********** question ********** ');
disp('try with A real but NOT symmetric. what happens with D? ');
disp('and the eigenvalues/eigenvectors found ? still good? why???');


