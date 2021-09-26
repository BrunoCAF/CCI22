function tests = testLabXQuadAluno
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)  % do not change function name

testCase.TestData.tolerance = 1e-2;

q1 = [1 0 1 0 0 -1];% circle
q2 = [1 1 0 0 0 -1];% hyperbole
q3 = [0 0 -4 1 0  1];% parabola
x0 = [-2; -1];  % Make a starting guess at the solution
tname = 'circle, hyp, parab NO exact intersect';
testCase.TestData.tcases = createQuadTestCase(q1,q2,q3,x0,tname);

x0 = [2; 2];  % Make a starting guess at the solution
testCase.TestData.tcases(end+1) = createQuadTestCase(q1,q2,q3,x0,tname);

% 3 circles meeting at the origin [0 0]
q1 = circle2quad([-1,0],1); 
q2 = circle2quad([1,0],1);
q3 = circle2quad([0,1],1);
x0 = [.5; .4];  % Make a starting guess at the solution
tname = '3 circles meeting at the origin';
testCase.TestData.tcases(end+1) = createQuadTestCase(q1,q2,q3,x0,tname);

x0 = [0; -2];  % Make a starting guess at the solution
testCase.TestData.tcases(end+1) = createQuadTestCase(q1,q2,q3,x0,tname);

% 2 parabolic, 1 circle, actual meeting at 1,1
q1 = circle2quad([-1,1],2);
q2 = [1 0 0 -2 -1 2];% parabolic  x
q3 = [0 0 1 -1 -2  2];% parabolic  y
x0 = [2; 2];  % Make a starting guess at the solution
tname = '2 parabolic one vertical, other horizontal; one circle; insersect at (1,1)';
testCase.TestData.tcases(end+1) = createQuadTestCase(q1,q2,q3,x0,tname);
x0 = [0; 0];  % Make a starting guess at the solution
testCase.TestData.tcases(end+1) = createQuadTestCase(q1,q2,q3,x0,tname);

end%setupOnce

function tc = createQuadTestCase(q1,q2,q3,x0,tname)
    tc.q1 = q1;
    tc.q2 = q2;
    tc.q3 = q3;
    tc.x0 = x0;
    tc.tname = tname;
    % solve non-linear equations, find intersection point of the 3 quadrics
    tc.options = optimoptions('fsolve','Display','none','Jacobian','on','Algorithm','levenberg-marquardt'); % Option to display output and use jacobians
    [tc.x3,tc.fval3,tc.exitflag3,tc.output3,tc.jacobian3]  = fsolve(@(x) F3(tc.q1,tc.q2,tc.q3,x),tc.x0,tc.options);
    [tc.x2,tc.fval2,tc.exitflag2,tc.output2,tc.jacobian2]  = fsolve(@(x) F(tc.q1,tc.q2,x),tc.x0,tc.options);
    
end % createQuadTestCase

function teardownOnce(testCase)  % do not change function name
end

function setup(testCase)    % do not change function name
end

function teardown(testCase) % do not change function name
end

function testQuad2(testCase)
for i = 1:length(testCase.TestData.tcases)
    tc = testCase.TestData.tcases(i);
    
    gab_sol = tc.x2;
    [your_sol] = mynonlinearsolver(@(x) F2(tc.q1,tc.q2,x),tc.x0);
    your_sol = your_sol(end,:)'; % only consider the last solution (last line)
    assertSizeEqual(testCase,gab_sol,your_sol);
    msg = [ '%Test Case: ' tc.tname char(10) ];
    msg = [ msg '%q1: ' quad2str(tc.q1) char(10) ]; 
    msg = [ msg '%q2: ' quad2str(tc.q2) char(10) ]; 
    %msg = [ msg '%q3: ' quad2str(tc.q3) char(10) ]; 
    x0 = tc.x0;
    msg = [ msg variable2message(x0) char(10) ];
    msg = [ msg '%repeating quadrics in vector format' char(10)];
    q1 = tc.q1; q2 = tc.q2; %q3 = tc.q3;
    msg = [ msg variable2message(q1,q2) char(10) ];
    assertAbsDiff(testCase,gab_sol,your_sol,testCase.TestData.tolerance,msg);
    
end %for
end%function

function testQuad3(testCase)
for i = 1:length(testCase.TestData.tcases)
    tc = testCase.TestData.tcases(i);
    
    gab_sol = tc.x3;
    [your_sol] = mynonlinearsolver(@(x) F3(tc.q1,tc.q2,tc.q3,x),tc.x0);
    your_sol = your_sol(end,:)'; % only consider the last solution (last line)
    assertSizeEqual(testCase,gab_sol,your_sol);
    msg = [ '%Test Case: ' tc.tname char(10) ];
    msg = [ msg '%q1: ' quad2str(tc.q1) char(10) ]; 
    msg = [ msg '%q2: ' quad2str(tc.q2) char(10) ]; 
    msg = [ msg '%q3: ' quad2str(tc.q3) char(10) ]; 
    x0 = tc.x0;
    msg = [ msg variable2message(x0) char(10) ];
    msg = [ msg '%repeating quadrics in vector format' char(10)];
    q1 = tc.q1; q2 = tc.q2; q3 = tc.q3;
    msg = [ msg variable2message(q1,q2,q3) char(10) ];
    assertAbsDiff(testCase,gab_sol,your_sol,testCase.TestData.tolerance,msg);
    
end %for
end%function

function testInverse(testCase)
tsizes = [ 4 4 4 4 8 8 8 8 16 16 16 16];
for i = 1:length(tsizes)
    
    A = generateWellCond(tsizes(i));
    
    matlab_iA = inv(A);
    % error is max element of I - A*invA
    matlab_inv_err = max(max(abs(eye(tsizes(i))-A*matlab_iA)));
        
    your_iA = myinv(A);
    % before calculating the error, check if size of answer is correct
    assertSizeEqual(testCase,A,your_iA); 
    % error is max element of I - A*invA
    your_inv_err = max(max(abs(eye(tsizes(i))-A*your_iA)));
        
    msg = [ 'Matrix to invert:' char(10) variable2message(A) char(10) ];
    msg = [ msg variable2message(your_iA,matlab_iA,your_inv_err,matlab_inv_err) char(10)];
    % you can have error much larger than matlab inv() function
    assertLessThan(testCase,your_inv_err,matlab_inv_err*1000,msg);
    
end %for
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

% asserts that two variables have the same value up to tolerance
% only works with inputs of one or two dimensions
function assertAbsDiff(testCase,a,b,tolerance,msg)
abserr = max(max(abs(a-b)));
msg = [ msg char(10) '%absolute error is too big: ' num2str(abserr) char(10) ];
msg = [ msg inputname(2) '= ' mat2str(a) char(10) ];
msg = [ msg inputname(3) '= ' mat2str(b) char(10) ];
assertLessThanOrEqual(testCase, abserr, tolerance, msg);
end%func

% asserts that two variables have the same value up to tolerance
% only works with inputs of one or two dimensions
function assertAbsDiffSmallMessage(testCase,a,b,tolerance,msg)
abserr = max(max(abs(a-b)));
msg = [ msg char(10) '%absolute error is too big: ' num2str(abserr) char(10) ];
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


% asserts that two variables have lengths close up to a tolerance
% does not check if dimmensions match, line aand collumn may be ok
function assertLengthClose(testCase,a,b,tol)

la = length(a);
lb = length(b);
length_diff = abs(la-lb);

msg = sprintf('%%variable %s has %d length; variable %s has %d length',inputname(2),la,inputname(3),lb);
msg = [msg char(10) sprintf('%%length difference is %d, can not be larger than %d!',length_diff,tol) ];
assertLessThanOrEqual(testCase,length_diff,tol,msg);

end%func





