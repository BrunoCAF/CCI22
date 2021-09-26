function tests = testLab6eigAluno
    tests = functiontests(localfunctions);
end
%% setup and teardown
function setupOnce(testCase)  % do not change function name
testCase.TestData.tolerance = 1e-6;
testCase.TestData.maxiter = 100;
testCase.TestData.testdatafile = 'testdataL6eig.mat';
if (exist(testCase.TestData.testdatafile,'file'))
    disp('******* loading test cases from file ***********');
    aux = load(testCase.TestData.testdatafile);
    testCase.TestData = aux.testCase.TestData;
else
    disp('******* start generating new test cases ***********');
    for i=1:20
        iplambda = NaN; % just to go the first while
        ipniter = testCase.TestData.maxiter;
        while(~isfinite(iplambda) || (ipniter >= testCase.TestData.maxiter)) % reject if inversepower does not work
            N = 3 + round(2 * rand());
            % generate real symetric well-conditioned matrix
            A = generateWellCond(N,@(x) 4*(x*x') );  
            [ipx,iplambda,ipniter]=ginvpowereig(A,testCase.TestData.maxiter);%#ok    
        end
        testCase.TestData.testCases(i).theroots = sort(rand(1,N));
        testCase.TestData.testCases(i).p = poly(testCase.TestData.testCases(i).theroots);
        [Q,R] = ghqr(A);
        [D,QQ,qrniter]=geigenqr(A,testCase.TestData.maxiter);
        testCase.TestData.testCases(i).A=A;
        testCase.TestData.testCases(i).ipx=ipx;
        testCase.TestData.testCases(i).iplambda=iplambda;
        testCase.TestData.testCases(i).ipniter=ipniter;
        testCase.TestData.testCases(i).Q=Q;
        testCase.TestData.testCases(i).R=R;
        testCase.TestData.testCases(i).D=D;
        testCase.TestData.testCases(i).QQ=QQ;
        testCase.TestData.testCases(i).qrniter=qrniter;
    end%for
    disp('***** finished generating new test cases, saving them ****');
    save(testCase.TestData.testdatafile,'testCase');
end%if

end%setupOnce

function teardownOnce(testCase)  % do not change function name
end
function setup(testCase)    % do not change function name
end
function teardown(testCase) % do not change function name
end

%% actual tests

function testInversePower(testCase)

disp('testing InversePower');
for i = 1:length(testCase.TestData.testCases)
    maxiter = testCase.TestData.maxiter;
    A =  testCase.TestData.testCases(i).A;
    gab_x =  testCase.TestData.testCases(i).ipx;
    gab_niter =  testCase.TestData.testCases(i).ipniter;
    gab_lambda = testCase.TestData.testCases(i).iplambda;
    gab_diverge = (gab_niter >= maxiter);
    
    
    [aluno_x, aluno_lambda, aluno_niter] = invpowereig(A,maxiter);
    aluno_diverge = (aluno_niter >= maxiter);
    
    
    msg = variable2message(A,maxiter,aluno_niter,gab_niter,aluno_diverge,gab_diverge,gab_lambda,aluno_lambda);
    %assertEqual(testCase,gab_diverge,aluno_diverge,['does it diverge ????' char(10) msg]);
    assertSizeEqual(testCase,gab_lambda,aluno_lambda);
    assertSizeEqual(testCase,gab_x,aluno_x);
       
    
    %assertAbsDiff(testCase,aluno_niter,gab_niter,2,msg);
    assertAbsDiff(testCase,aluno_lambda,gab_lambda,testCase.TestData.tolerance,msg);
    assertAbsDiff(testCase,abs(aluno_x),abs(gab_x),testCase.TestData.tolerance,msg);
    
end%for
end%function


function testHQR(testCase)

disp('testing QR decomposition via householder');

for i = 1:length(testCase.TestData.testCases)
    maxiter = testCase.TestData.maxiter;
    A =  testCase.TestData.testCases(i).A;
    gab_Q =  testCase.TestData.testCases(i).Q;
    gab_R =  testCase.TestData.testCases(i).R;
      
    
    [aluno_Q, aluno_R] = hqr(A);
    
    assertSizeEqual(testCase,gab_Q,aluno_Q);
    assertSizeEqual(testCase,gab_R,aluno_R);
       
    msg = variable2message(A);
    assertAbsDiff(testCase,aluno_Q,gab_Q,testCase.TestData.tolerance,msg);
    assertAbsDiff(testCase,aluno_R,gab_R,testCase.TestData.tolerance,msg);
    
end%for
end%function

function testEigenQR(testCase)

disp('testing eigenvalues via iterative QR');
for i = 1:length(testCase.TestData.testCases)
    maxiter = testCase.TestData.maxiter;
    A =  testCase.TestData.testCases(i).A;
    gab_D =  testCase.TestData.testCases(i).D;
    gab_QQ =  testCase.TestData.testCases(i).QQ;
    gab_niter =  testCase.TestData.testCases(i).qrniter;
    gab_diverge = (gab_niter >= maxiter);  
    
    [aluno_D,aluno_QQ,aluno_niter]=eigenqr(A,maxiter);
    aluno_diverge = (aluno_niter >= maxiter);
    
    assertEqual(testCase,gab_diverge,aluno_diverge,'does it diverge ????');
    assertSizeEqual(testCase,gab_D,aluno_D);
    assertSizeEqual(testCase,gab_QQ,aluno_QQ);
       
    msg = variable2message(A,maxiter);
    assertAbsDiff(testCase,aluno_niter,gab_niter,2,msg);
    assertAbsDiff(testCase,aluno_QQ,gab_QQ,testCase.TestData.tolerance,msg);
    assertAbsDiff(testCase,aluno_D,gab_D,testCase.TestData.tolerance,msg);
    
end%for
end%function


function testPolyCompanion(testCase)

disp('testing finding roots via companion matrix');

for i = 1:length(testCase.TestData.testCases)
    gab_roots = testCase.TestData.testCases(i).theroots;
    p = testCase.TestData.testCases(i).p;
         
    aluno_roots = polyRootCompanion(p);
        
    assertSizeEqual(testCase,gab_roots,aluno_roots);
       
    msg = variable2message(p);

assertAbsDiff(testCase,aluno_roots,gab_roots,testCase.TestData.tolerance*1e3,msg);
    
end%for
end%function



%% auxiliary functions for tests
%% attention: aux functions can NOT have 'test' in their names

% given variables, construct a string message with, for each variable:
% <variable_name>= <variable_value> <end_of_line>
function msg = variable2message(varargin)
msg = [];
for i=1:length(varargin)
    msg = [ msg inputname(i) '= ' mat2str(varargin{i}) char(10) ];
end%for
end

% asserts that two variables have the same size
% only works with inputs of one or two dimensions
function assertAbsDiff(testCase,a,b,tolerance,msg)
abserr = max(max(abs(a-b)));
msg = [ msg char(10) '%absolute error is too big: ' num2str(abserr) char(10) ];
msg = [ msg inputname(2) '= ' mat2str(a) char(10) ];
msg = [ msg inputname(3) '= ' mat2str(b) char(10) ];
assertLessThanOrEqual(testCase, abserr, tolerance, msg);
end%func

% asserts that two variables have the same size
% only works with inputs of one or two dimensions
function assertSizeEqual(testCase,a,b)

[la,ca] = size(a);
[lb,cb] = size(b);

msg = sprintf('%%variable %s has %d lines; variable %s has %d lines',inputname(2),la,inputname(3),lb);
msg = [msg char(10) '%They must have the same number of lines!'];
assertEqual(testCase,la,lb,msg);
msg = sprintf('%%variable %s has %d collumns; variable %s has %d collumns',inputname(2),ca,inputname(3),cb);
msg = [msg char(10) '%They must have the same number of collumns!'];
assertEqual(testCase,ca,cb,msg);
end%func