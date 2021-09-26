function tests = testLab1Aluno
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)  % do not change function name
    testCase.TestData.tolerance = 1e-14;
end

function teardownOnce(testCase)  % do not change function name

end

function setup(testCase)    % do not change function name

end

function teardown(testCase) % do not change function name

end

function testOrdSmall(testCase)
for i = 1:9
    orig = (100 * rand(10,5));
    expected = sortrows(orig); 
    yours = mysortrows(orig);
    msg = [ 'sortrows failed with small matrices' char(10) ];
    assertAbsDiff(testCase,yours, expected, testCase.TestData.tolerance , msg)
end
end

function testOrd(testCase)
for i = 1:9
    orig = (100 * rand(1e4,10));
    expected = sortrows(orig); 
    your_answer = mysortrows(orig);
    assertAbsDiffSmallMessage(testCase,your_answer, expected, testCase.TestData.tolerance ,'sort rows failed')
end
end

function testOrdInteiros(testCase)
for i = 1:5
    orig = round(100 * rand(1e4,10));
    expected = sortrows(orig); 
    your_answer = mysortrows(orig);
    assertAbsDiffSmallMessage(testCase,your_answer, expected, testCase.TestData.tolerance ,'sort rows failed')
end
end

function testOrdTimed(testCase)
for i = 1:20
    orig = (100 * rand(5e4,100));
    expected = sortrows(orig); 
    your_answer = mysortrows(orig);
    assertAbsDiffSmallMessage(testCase,your_answer, expected, testCase.TestData.tolerance ,'sort rows failed') 
end
end



function testexp(testCase)
for i = 1:30
    x = 100*rand();
    [expx_es400,err_es400] = expseries(x,400);
    [expx_aluno,err_aluno] = myexp(x);
    true_exp_x = exp(x);
    relative_tolerance = max(10*abs(err_es400),100*eps);
    msg = [ 'relative error is too large: ' char(10) variable2message(x,true_exp_x,expx_es400,expx_aluno,err_es400, err_aluno) ] ;
    assertLessThanOrEqual(testCase, abs(err_aluno), relative_tolerance , msg);
    
    % do not test absolute value
    % some values where exp(x) is large have small relative errors but 
    % significant absolute error depending on the method or order of operations
    % I have seen  x= 34.92964145212808091400802 with 0.25 absolute error
    %abs_err_es400 = abs(exp(x)-expx_es400);
    %abs_err_aluno = abs(exp(x)-expx_aluno);
    %absolute_tolerance = max(10*abs_err_es400,100*eps);
    %msg = [ 'absolute error is too large: ' char(10) variable2message( x,true_exp_x,expx_es400, expx_aluno, abs_err_es400, abs_err_aluno ) ] ;
    %assertLessThanOrEqual(testCase,abs_err_aluno ,absolute_tolerance, msg);
end%for
end


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


