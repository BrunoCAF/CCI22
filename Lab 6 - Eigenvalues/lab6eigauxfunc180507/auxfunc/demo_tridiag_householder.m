clear all;
A = rand(5); 
% ******** TRY WITH NON-SYMETRIC *************
% this line force A to be symetric
A = (A * A')*0.5;  %comment to try with non-symetric!
% ***********************************************
[v,d] = eig(A);
eigA = diag(d)';% the eigenvalues

% matriz example on wikipedia
%A = [ 4 1 -2 2 ; 1 2 0 1 ;-2 0 3 -2 ; 2 1 -2 -1 ];

[M,PP,allA,allP] = householderTridiagonalization(A);

disp('**********  DEMO TRIDIAGONALIZATION VIA HOUSEHOLDER **********')
pr(A,'input matrix');
pr(eigA,'input matrix eigenvalues');
pr(M,'final tridiagonalized matrix',1e-15);

disp(['show it is really a decomposition']) ;
decompAfromM = PP * M * PP';
max_errorA_from_M = max(max(abs(decompAfromM - A)));
pr(max_errorA_from_M)

disp([ char(10) 'show the householder reflextion matrices at each iteration' ]) ;
disp('for each iteration i, M_i = P_i * M_i-1 * P_i  and M_0 = A')
pr(A,'input matrix is M_0');
for iter = 1:size(allA,3) 
   disp(['------ iter ' num2str(iter) '------------']);
   currentM = allA(:,:,iter); currentP=allP(:,:,iter);
   pr(currentP,[ 'P' num2str(iter) ],1e-15);
   pr(currentM,[ 'M' num2str(iter) ' = P_' num2str(iter) ' * M_' num2str(iter-1) ' * P_' num2str(iter) ],1e-15);
   
    
end%for

disp('check: PP and each allP(:,:,i) are orthonormal')
orthoPP_error = orthogonalError(PP);
for iter = 1:size(allA,3) 
    orthoP(iter) =  orthogonalError(allP(:,:,iter));
end
orthoP_error = max(orthoP);
table(orthoP_error,orthoPP_error)

disp(['check: at each step, both collumn below the tridiagonal ' char(10) '            and line right to tridiagonal are zeroed'])
disp('check: not true for the householder reflexion which tries to diagonalize instead of tri-diagonalize!')
disp('check: try with a non-symetric matrix. does it still get tridiagonal results?')

