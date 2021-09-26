function tests = testLab5fitAluno
    tests = functiontests(localfunctions);
end
%% setup and teardown
function setupOnce(testCase)  % do not change function name
testCase.TestData.tolerance = 1e-6;
for i=1:10
    N = 100 + ceil(200 * rand());
    x = -100 + rand(N, 1) * 200;
    x2 = -100 + rand(N, 1) * 200;
    y = -100 + rand(N, 1) * 200;
    x = sort(x);
    x2 = sort(x2);
    y = sort(y);
    Phi = GeneratePhi();
    mqc = gMinimosQuadrados(Phi, x, y);
    [rlc, rlr] = gRegressaoLinear(x, y);
    rl2c = gRegressaoLinear2D(x, x2, y);
    testCase.TestData.testCases(i).Phi = Phi;
    testCase.TestData.testCases(i).x = x;
    testCase.TestData.testCases(i).x2 = x2;
    testCase.TestData.testCases(i).y = y;
    testCase.TestData.testCases(i).mqc = mqc;
    testCase.TestData.testCases(i).rlc = rlc;
    testCase.TestData.testCases(i).rlr = rlr;
    testCase.TestData.testCases(i).rl2c = rl2c;
    testCase.TestData.testCases(i).trilatprob = generatetrilatTestCase();
end%for



end%setupOnce

function teardownOnce(testCase)  % do not change function name
end
function setup(testCase)    % do not change function name
end
function teardown(testCase) % do not change function name
end

%% actual tests

function testMinimosQuadrados(testCase)

disp('testing MinimosQuadrados');
for i = 1:length(testCase.TestData.testCases)
    x =  testCase.TestData.testCases(i).x;
    y =  testCase.TestData.testCases(i).y;
    phi =  testCase.TestData.testCases(i).Phi;
    
    aluno_c = MinimosQuadrados(phi, x, y);
    gab_c = testCase.TestData.testCases(i).mqc;
    
    assertSizeEqual(testCase,gab_c,aluno_c);
       
    msg = variable2message(x,y);
    for i=1:length(phi)
        msg = [ msg 'Phi{' num2str(i) '}= ' func2str(phi{i}) char(10) ];
    end
    assertAbsDiff(testCase,aluno_c,gab_c,testCase.TestData.tolerance,msg);
    
end%for
end%function

function testRegressaoLinear(testCase)

disp('testing RegressaoLinear');
for i = 1:length(testCase.TestData.testCases)
    x =  testCase.TestData.testCases(i).x;
    y =  testCase.TestData.testCases(i).y;
    
    [aluno_c, aluno_r] = RegressaoLinear(x, y);
    gab_c = testCase.TestData.testCases(i).rlc;
    gab_r = testCase.TestData.testCases(i).rlr;
    
    assertSizeEqual(testCase,gab_c,aluno_c);
    assertSizeEqual(testCase,gab_r,aluno_r);
       
    msg = variable2message(x,y);
    assertAbsDiff(testCase,aluno_c,gab_c,testCase.TestData.tolerance,msg);
    assertAbsDiff(testCase,aluno_r,gab_r,testCase.TestData.tolerance,msg);
    
end%for
end%function

function testRegressaoLinear2D(testCase)

disp('testing RegressaoLinear2D');
for i = 1:length(testCase.TestData.testCases)
    x =  testCase.TestData.testCases(i).x;
    x2 =  testCase.TestData.testCases(i).x2;
    y =  testCase.TestData.testCases(i).y;
    
    aluno_c = RegressaoLinear2D(x, x2, y);
    gab_c = testCase.TestData.testCases(i).rl2c;
    assertSizeEqual(testCase,gab_c,aluno_c);
       
    msg = variable2message(x,x2,y);
    assertAbsDiff(testCase,aluno_c,gab_c,testCase.TestData.tolerance,msg);
    
end%for
end%function


function testcalcAandBforTrilateration(testCase)

disp('testing calcAandBforTrilateration');
for i = 1:length(testCase.TestData.testCases)
    x =  testCase.TestData.testCases(i).trilatprob.x;
    y =  testCase.TestData.testCases(i).trilatprob.y;
    b =  testCase.TestData.testCases(i).trilatprob.b;
    beacons = testCase.TestData.testCases(i).trilatprob.beacons;
    truepose = testCase.TestData.testCases(i).trilatprob.truepose;
    
    [aluno_Ahat,aluno_bhat] = calcAandBforTrilateration(x,y,b);
    
    gab_Ahat = testCase.TestData.testCases(i).trilatprob.Ahat;
    gab_bhat = testCase.TestData.testCases(i).trilatprob.bhat;
    assertSizeEqual(testCase,gab_Ahat,aluno_Ahat);
    assertSizeEqual(testCase,gab_bhat,aluno_bhat);
       
    msg = variable2message(beacons,truepose,x,y,b);
    assertAbsDiff(testCase,aluno_Ahat,gab_Ahat,testCase.TestData.tolerance,msg);
    assertAbsDiff(testCase,aluno_bhat,gab_bhat,testCase.TestData.tolerance,msg);
    
end%for
end%function

% this is not a test, it generates a test case for the trilateration
% problem. the result is a struct with the data corresponding to one
% trilateration problem.
function [trilatprob] = generatetrilatTestCase()
    % problem data.
    n_beacons = 5 + round(5*rand);
    range_error = 0.5 + 0.5*rand;
    beacons = 10 * rand(n_beacons,2);
    truepose = 10 * rand(2,1);

    trueranges = ((beacons(:,1)-truepose(1)).^2 + (beacons(:,2)-truepose(2)).^2).^0.5 ;
    ranges = trueranges + range_error * rand(size(trueranges)); % uniform error
    %ranges = trueranges + range_error * randn(size(trueranges)); % normal error

    [n aux] = size(beacons);

    % linearized linear system from Savarese thesis
    A = -2 * [ (beacons(1:n-1,1) - beacons(n,1)) (beacons(1:n-1,2) - beacons(n,2))];

    % b is the initial right part of the system before least squares derivation
    b = ranges(1:n-1).^2 - beacons(1:n-1,1).^2 -  beacons(1:n-1,2).^2;
    b = b - ranges(n)^2 + beacons(n,1)^2 + beacons(n,2)^2;

    % auxiliary matrices. just to do xi-xn
    x = beacons(1:n-1,1) - beacons(n,1); %  beacon_x_i - beacon_x_n
    y = beacons(1:n-1,2) - beacons(n,2); %  beacon_y_i - beacon_y_n
    
    [Ahat,bhat] = gcalcAandBforTrilateration(x,y,b);
    
    % fill the result
    trilatprob.beacons = beacons;
    trilatprob.truepose = truepose;
    trilatprob.x = x;
    trilatprob.y = y;
    trilatprob.b = b;
    trilatprob.A = A;
    trilatprob.Ahat = Ahat;
    trilatprob.bhat = bhat;
    %[pos,poslcov,posinv,ts] = trilateration(beacons,ranges);
end % func

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