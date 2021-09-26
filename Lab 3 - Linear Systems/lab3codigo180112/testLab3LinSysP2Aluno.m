function tests = testLab3LinSysP2Aluno
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)  % do not change function name
sizes = [3 3 3 3 4 4 4 4 ];
testCase.TestData.sizes = sizes;
testCase.TestData.tolerance = 1e-5;
testCase.TestData.maxIteracoes = 100;  
testCase.TestData.datafilename = 'DataLab3P2.mat';

if (~exist(testCase.TestData.datafilename,'file'))
    disp('I need to generate data. go away and take a coffe.');
    for i=1:length(sizes)
        [A,b] = generateLinhasOk(sizes(i));
        [gx, gdr] = gGaussJacobi(A,b, zeros(sizes(i),1), testCase.TestData.tolerance, testCase.TestData.maxIteracoes);
        dataLinOk(i).A = A;
        dataLinOk(i).b = b;
        dataLinOk(i).x = gx;
        dataLinOk(i).dr = gdr;
        invCrit = @(A) ~gCriterioLinhas(A); %nao passa no crit linhas
        [A,b] = generateWellCond(sizes(i),[],invCrit);
        dataLinBad(i).A = A;
        dataLinBad(i).b = b;
    end
    disp('data generated for Linhas and Gauss Jacobi');
    for i=1:length(sizes)
        [A,b] = generateSassenfeldOk(sizes(i));
        [gx, gdr] = gGaussSeidel(A,b, zeros(sizes(i),1), testCase.TestData.tolerance, testCase.TestData.maxIteracoes);
        dataSsfOk(i).A = A;
        dataSsfOk(i).b = b;
        dataSsfOk(i).x = gx;
        dataSsfOk(i).dr = gdr;
        invCrit = @(A) ~gCriterioSassenfeld(A); %nao passa no sassenfeld
        [A,b] = generateWellCond(sizes(i),[],invCrit);
        dataSsfBad(i).A = A;
        dataSsfBad(i).b = b;
    end
    disp('data generated for Sassenfeld and Gauss Seidel');
    
    save( testCase.TestData.datafilename,'dataLinOk','dataLinBad','dataSsfOk','dataSsfBad');
    
else%if exists
    disp('loading data...');
    load(testCase.TestData.datafilename);
    disp('loaded data...');
end%if

testCase.TestData.linok = dataLinOk;
testCase.TestData.linbad = dataLinBad;
testCase.TestData.ssfok = dataSsfOk;
testCase.TestData.ssfbad = dataSsfBad;

end% setup global

function teardownOnce(testCase)  % do not change function name
end

function setup(testCase)    % do not change function name
end

function teardown(testCase) % do not change function name
end

function testCriterioLinhas(testCase)
sizes = testCase.TestData.sizes;
sizes = sizes(sizes<5);
disp('testing CriterioLinhas');
for i = 1:2:length(sizes)
    
    A = testCase.TestData.linok(i).A;    
    resaluno = CriterioLinhas(A);
    
    msg = [ 'A satisfies CriterioLinhas: ' char(10) ];
    msg = [ msg 'A = ' mat2str(A) char(10) ];
    msg = [ msg 'but your function says it does not' ];
    assertEqual(testCase, round(resaluno), 1, msg);
    
end%for
for i = 2:2:length(sizes)
    
    A = testCase.TestData.linbad(i).A;
    resaluno = CriterioLinhas(A);
    
    msg = [ 'A does NOT satisfies CriterioLinhas: ' char(10) ];
    msg = [ msg 'A = ' mat2str(A) char(10) ];
    msg = [ msg 'but your function says it does!' ];
    assertEqual(testCase, round(resaluno), 0, msg);
    
end%for
end%function

function testCriterioSassenfeld(testCase)
sizes = testCase.TestData.sizes;
sizes = sizes(sizes<5);
disp('testing CriterioSassenfeld');
for i = 1:2:length(sizes)
    
    A = testCase.TestData.ssfok(i).A; 
    resaluno = CriterioSassenfeld(A);
    
    msg = [ 'A satisfies CriterioSassenfeld: ' char(10) ];
    msg = [ msg 'A = ' mat2str(A) char(10) ];
    msg = [ msg 'but your function says it does not' ];
    assertEqual(testCase, round(resaluno), 1, msg);
    
end%for
for i = 2:2:length(sizes)
    
    A = testCase.TestData.ssfbad(i).A;
    resaluno = CriterioSassenfeld(A);
    
    msg = [ 'A does NOT satisfies CriterioSassenfeld: ' char(10) ];
    msg = [ msg 'A = ' mat2str(A) char(10) ];
    msg = [ msg 'but your function says it does!' ];
    assertEqual(testCase, round(resaluno), 0, msg);
    
end%for
end%function


function testGaussJacobi(testCase)
sizes = testCase.TestData.sizes;
sizes = sizes(sizes<5);
disp('testing GaussJacobi');
for i = 1:length(sizes)
    A = testCase.TestData.linok(i).A;
    b = testCase.TestData.linok(i).b;
    gx = testCase.TestData.linok(i).x;
    gdr = testCase.TestData.linok(i).dr;
    
    [ax, adr] = GaussJacobi(A,b, zeros(sizes(i),1), testCase.TestData.tolerance, testCase.TestData.maxIteracoes);
    
    gdiverged = (gdr(end) > testCase.TestData.tolerance);
    adiverged = (adr(end) > testCase.TestData.tolerance);
    
    difference = max(abs(ax - gx));
    
    msg = [ 'GaussJacobi with: ' char(10) ];
    msg = [ msg 'A = ' mat2str(A) char(10) ];
    msg = [ msg 'b = ' mat2str(b) char(10) ];
    msg = [ msg ' it diverges (1=yes, 0=no): ' num2str(gdiverged) ];
    msg = [ msg ' your function says it diverges (1=yes, 0=no): ' num2str(adiverged) ];
    assertEqual(testCase, round(adiverged), round(gdiverged), msg);
    
    msg = [ 'absolute error is too big!' ];
    msg = [ msg 'A: ' mat2str(A) char(10) ];
    msg = [ msg 'b: ' mat2str(b) char(10) ];
    msg = [ msg 'your    x: ' mat2str(ax) char(10) ];
    msg = [ msg 'correct x: ' mat2str(gx) char(10) ];
    assertLessThanOrEqual(testCase, difference, testCase.TestData.tolerance, msg);
    
end%for
end%function


function testGaussSeidel(testCase)
sizes = testCase.TestData.sizes;
sizes = sizes(sizes<5);
disp('testing GaussSeidel');
for i = 1:length(sizes)
    
    A = testCase.TestData.ssfok(i).A;
    b = testCase.TestData.ssfok(i).b;
    gx = testCase.TestData.ssfok(i).x;
    gdr = testCase.TestData.ssfok(i).dr;
    
    [ax, adr] = GaussSeidel(A,b, zeros(sizes(i),1), testCase.TestData.tolerance, testCase.TestData.maxIteracoes);
    
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


