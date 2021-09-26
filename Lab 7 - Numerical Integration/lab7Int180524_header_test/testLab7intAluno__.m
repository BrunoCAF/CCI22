function tests = testProfLab7int
    tests = functiontests(localfunctions);
end
%% setup and teardown
function setupOnce(testCase)  % do not change function name
testCase.TestData.tolerance = 1e-6;
%testCase.TestData.maxiter = 100;
testCase.TestData.testdatafile = 'testdataL7int.mat';
if (exist(testCase.TestData.testdatafile,'file'))
    disp('******* loading test cases from file ***********');
    aux = load(testCase.TestData.testdatafile);
    testCase.TestData = aux.testCase.TestData;
else
    disp('******* start generating new test cases ***********');
    for i=1:20
        h = 0.1 * rand();
        a = -5 + 5 * rand();
        b = a + 3 * h + 5 * rand();
        x = a:h:b;
        if mod(length(x), 2) == 0
            x = x(1:end-1); % makes x odd for simpson to work
            b = x(end); % updates end of intervall
        end
        epsilon = 10^(-3 - round(2 * rand()));
        f = GenerateTestFunction(i);
        y = f(x);
        y = y';
        
        
        Itrap = gIntegracaoTrapezio(h, y);
        Isimp = gIntegracaoSimpson(h, y);
        [Iq, Qpt] = gIntegracaoQuadraturaAdaptativa(f, a, b, epsilon);
        
        testCase.TestData.testCases(i).h=h;
        testCase.TestData.testCases(i).a=a;
        testCase.TestData.testCases(i).b=b;
        testCase.TestData.testCases(i).x=x;
        testCase.TestData.testCases(i).epsilon=epsilon;
        testCase.TestData.testCases(i).y=y;
        testCase.TestData.testCases(i).f=func2str(f);
        testCase.TestData.testCases(i).Itrap=Itrap;
        testCase.TestData.testCases(i).Isimp=Isimp;
        testCase.TestData.testCases(i).Iq=Iq;
        testCase.TestData.testCases(i).Qpt=Qpt;
        
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



function f = GenerateTestFunction(idx)

ff{1} = @(x) 1 + 2 * x;
ff{2} = @(x) x.^2 + x;
ff{3} = @(x) sin(x) + cos(x);
ff{4} = @(x) exp(x)/2;

f= ff{mod(idx,length(ff))+1};

end%func

%% actual tests

function testIntegracaoTrapezio(testCase)

disp('testing IntegracaoTrapezio');
for i = 1:length(testCase.TestData.testCases)
    
    h =  testCase.TestData.testCases(i).h;
    y =  testCase.TestData.testCases(i).y;
    fstr =  testCase.TestData.testCases(i).f;
    gab_I =  testCase.TestData.testCases(i).Itrap;
        
    aluno_I = IntegracaoTrapezio(h, y);
    
    assertSizeEqual(testCase,gab_I,aluno_I);
       
    msg = variable2message(h,y,fstr);
    assertAbsDiff(testCase,aluno_I,gab_I, testCase.TestData.tolerance ,msg);
    
end%for
end%function

function testIntegracaoSimpson(testCase)

disp('testing IntegracaoSimpson');
for i = 1:length(testCase.TestData.testCases)
    
    h =  testCase.TestData.testCases(i).h;
    y =  testCase.TestData.testCases(i).y;
    fstr =  testCase.TestData.testCases(i).f;
    gab_I =  testCase.TestData.testCases(i).Isimp;
        
    aluno_I = IntegracaoSimpson(h, y);
    
    assertSizeEqual(testCase,gab_I,aluno_I);
       
    msg = variable2message(h,y,fstr);
    assertAbsDiff(testCase,aluno_I,gab_I, testCase.TestData.tolerance ,msg);
    
end%for
end%function


function testIntegracaoQuadratura(testCase)

disp('testing IntegracaoQuadratura');
for i = 1:length(testCase.TestData.testCases)
    
    h =  testCase.TestData.testCases(i).h;
    a =  testCase.TestData.testCases(i).a;
    b =  testCase.TestData.testCases(i).b;
    epsilon = testCase.TestData.testCases(i).epsilon;
    fstr =  testCase.TestData.testCases(i).f;
    f = str2func(fstr);
    
    gab_I =  testCase.TestData.testCases(i).Iq;
    gab_x =  testCase.TestData.testCases(i).Qpt;
    
    [aluno_I, aluno_x] = IntegracaoQuadraturaAdaptativa(f,a,b, epsilon);
    
    assertSizeEqual(testCase,gab_I,aluno_I);
    assertLengthClose(testCase,gab_x,aluno_x, ceil(0.7 * length(gab_x)) );
       
    msg = variable2message(h,a,b,epsilon,fstr);
    assertAbsDiff(testCase,aluno_I,gab_I, epsilon ,msg);
    
    
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
