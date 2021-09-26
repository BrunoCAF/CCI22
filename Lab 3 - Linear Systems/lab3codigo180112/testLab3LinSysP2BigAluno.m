function tests = testLab3LinSysP2BigAluno
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)  % do not change function name
testCase.TestData.tolerance = 1e-5;
testCase.TestData.maxIteracoes = 100;
end

function teardownOnce(testCase)  % do not change function name
end

function setup(testCase)    % do not change function name
end

function teardown(testCase) % do not change function name
end


function testGaussSeidelBig(testCase)
sizes = [100 200 500];

disp('testing GaussSeidel');
for i = 1:length(sizes)
    [A,b] = genSpSassenfeldOk(sizes(i));
    
    [ax, adr] = GaussSeidel(A,b, zeros(sizes(i),1), testCase.TestData.tolerance, testCase.TestData.maxIteracoes);
    [gx, gdr] = gGaussSeidel(A,b, zeros(sizes(i),1), testCase.TestData.tolerance, testCase.TestData.maxIteracoes);
    gdiverged = (gdr(end) > testCase.TestData.tolerance);
    adiverged = (adr(end) > testCase.TestData.tolerance);
    
    difference = max(abs(ax - gx));
    
    msg = [ 'GaussSeidel with: ' char(10) ];
    msg = [ msg 'A = ' mat2str(A) char(10) ];
    msg = [ msg 'b = ' mat2str(b) char(10) ];
    msg = [ msg ' it diverges (1=yes, 0=no): ' num2str(gdiverged) ];
    msg = [ msg ' your function says it diverges (1=yes, 0=no): ' num2str(adiverged) ];
    assertEqual(testCase, round(adiverged), round(gdiverged), msg);
    
    msg = [ 'GaussSeidel absolute error is too big!' ];
    msg = [ msg 'A: ' mat2str(A) char(10) ];
    msg = [ msg 'b: ' mat2str(b) char(10) ];
    msg = [ msg 'your    x: ' mat2str(ax) char(10) ];
    msg = [ msg 'correct x: ' mat2str(gx) char(10) ];
    assertLessThanOrEqual(testCase, difference, testCase.TestData.tolerance, msg);
    
end%for
end%function


