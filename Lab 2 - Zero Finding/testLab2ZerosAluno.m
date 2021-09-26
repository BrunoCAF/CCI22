function tests = testLab2ZerosAluno
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)  % do not change function name
load testCases
disp('Loading TestCases Ponto Fixo');
testCase.TestData.I1PF = testCases.I1PF;
disp('Loading TestCases Newton');
testCase.TestData.I2NR = testCases.I2NR;
disp('Loading TestCases Secante');
testCase.TestData.I3SC = testCases.I3SC;

testCase.TestData.tolerance = 1e-6;
end

function teardownOnce(testCase)  % do not change function name

end

function setup(testCase)    % do not change function name

end

function teardown(testCase) % do not change function name

end

function testPontoFixo(testCase)
disp('testing Ponto Fixo');    
for i = 1:length(testCase.TestData.I1PF)
    t = testCase.TestData.I1PF(i);
    t.f = str2func(t.f);
    disp([ 'run ' func2str(t.f) ' ...']);  
    [your_r,your_n] = PosicaoFalsa(t.f, t.a, t.b, t.epsilon, t.maxIteracoes);
    gab_r = t.r;
    gab_n = t.n;
    
    msg = [ '%absolute error too big for function: ' func2str(t.f)];  
    assertAbsDiff(testCase,your_r,gab_r,testCase.TestData.tolerance,msg)

    
    msg = [ '%unexpected number of iterations for function: ' func2str(t.f)];
    msg = [msg char(10) '   %it should be around ' int2str(t.n) ' iterations'];
    assertAbsDiff(testCase,your_n,gab_n,ceil(0.1 * gab_n),msg)
    
end%for
end%function



function testNewton(testCase)
disp('testing Newton Rapson');    
for i = 1:length(testCase.TestData.I2NR)
    t = testCase.TestData.I2NR(i);
    t.f = str2func(t.f);
    t.df = str2func(t.df);
    disp([ 'run ' func2str(t.f) ' ...']);  
    
    [your_r,your_n] = NewtonRaphson(t.f, t.df, t.x0, t.epsilon, t.maxIteracoes);
    
    gab_r = t.r;
    gab_n = t.n;
    
    msg = ['%your number of iterations can not be larger than ' num2str(t.maxIteracoes+1) ' '];
    assertLessThanOrEqual(testCase, your_n, t.maxIteracoes+1, msg);
    
    % does it converge or diverge?
    diverged = (your_n == t.maxIteracoes || your_n == (t.maxIteracoes + 1));
    should_diverge = (t.n == t.maxIteracoes);
    msg = [ '%it diverges (1 yes, 0 no): ' num2str(should_diverge) char(10) ];
    msg = [ msg '%your result diverges (1 yes, 0 no): ' num2str(diverged) ];
    assertEqual(testCase,diverged,should_diverge, msg);
    
    if (~should_diverge) % if it diverges, values do not matter
        msg = [ 'absolute error too big for function: ' func2str(t.f)]; 
        assertAbsDiff(testCase,your_r,gab_r,testCase.TestData.tolerance,msg)
        
        msg = [ 'unexpected number of iterations for function: ' func2str(t.f)];
        msg = [msg char(10) '   it should be around ' int2str(t.n) ' iterations'];
        assertAbsDiff(testCase,your_n,gab_n,ceil(0.1 * gab_n),msg)    
    end%if
    
end%for
end%function


function testSecant(testCase)
disp('testing Secante');    
for i = 1:length(testCase.TestData.I3SC)
    t = testCase.TestData.I3SC(i);
    t.f = str2func(t.f);
    disp([ 'run ' func2str(t.f) ' ...']);  
    [your_r,your_n] = Secante(t.f, t.x0, t.x1, t.epsilon, t.maxIteracoes);
    gab_r = t.r;
    gab_n = t.n;
    
    
    msg = [ 'absolute error too big for function: ' func2str(t.f)]; 
    assertAbsDiff(testCase,your_r,gab_r,testCase.TestData.tolerance,msg)
    
    msg = [ 'unexpected number of iterations for function: ' func2str(t.f)];
    msg = [msg char(10) '   it should be around ' int2str(t.n) ' iterations'];
    assertAbsDiff(testCase,your_n,gab_n,ceil(0.1 * gab_n),msg)    
    
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




