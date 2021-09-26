
% bad example! try it. what happens???
 Abad = [10.6	     5.88	     5.61	     3.86;
         5.88	      5.2	     4.08	     2.25;	
         5.61	     4.08	     4.63	     1.54;	
         3.86	     2.25	     1.54	     1.76];

% *** TRY *** try a random matrix, see what happens SOMETIMES if cond(A) is too big 
%A = rand(4);
%A = A*A'*4; % this line makes it symetric
A = generateWellCond(4,@(x) 4*(x*x') ); % random WELL-CONDITIONED symetric matrix.
%A = hilb(7); %% try with hilbert (surprise)

[v,l] = eig(A);
eigA = ((diag(l)'));

[x,lambda,niter] = ginvpowereig(A,1000);
condA = cond(A);

% looks for the nearest eigenvalue. calculates the difference
error_eigvalues = min(abs(lambda-eigA));

pr(A,'************* input matrix ***********');
pr(eigA,'its eigenvalues and eigenvectors from eig()')
pr(v)
pr(x,'eigenvector from inverse power method')
disp(table(error_eigvalues,niter,lambda,condA))

disp('********* question **********'); 
disp('IPM implementation starts with mu=1 and x = [1 1 ... 1]''  ')
disp('check: which eigenvector/value pair was found? ');
disp('why exactly this pair? does it make sense?');
disp('********* question **********'); 
disp('sometimes, the eigenvector found has opposite signal');
disp('i.e: v_eig = - v_ipm         why?');
disp('********* question **********'); 
disp('what happens with the bad example?');





