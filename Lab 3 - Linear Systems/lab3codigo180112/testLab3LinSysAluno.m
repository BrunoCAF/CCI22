function tests = testLab3LinSysAluno
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)  % do not change function name
sizes = [3 3 3 3 3 4 4 4 4 4 5 5 10:10:100];
testCase.TestData.sizes = sizes;
testCase.TestData.tolerance = 1e-6;

end

function teardownOnce(testCase)  % do not change function name
end

function setup(testCase)    % do not change function name
end

function teardown(testCase) % do not change function name
end

function testSolTriangularSuperior(testCase)
sizes = testCase.TestData.sizes;
disp('testing SolTriangularSuperior');
for i = 1:length(sizes)
    
    %A = triu(rand(sizes(i)));
    %b = rand(sizes(i),1);
    [A,b] = generateWellCond(sizes(i),@(x) triu(forceWellCond(x)) );
    
    x = SolucaoTriangularSuperior(A,b);
    gabx = gSolucaoTriangularSuperior(A,b);
    
    abserr = max(abs(x - gabx));
    
    msg = [ 'absolute error is too big: ' num2str(abserr) char(10) ];
    msg = [ msg 'A: ' mat2str(A) char(10) ];
    msg = [ msg 'b: ' mat2str(b) char(10) ];
    msg = [ msg 'your    x: ' mat2str(x) char(10) ];
    msg = [ msg 'correct x: ' mat2str(gabx) char(10) ];
    assertLessThanOrEqual(testCase, abserr, testCase.TestData.tolerance, msg);
    
end%for
end%function

function testSolTriangularInferior(testCase)
sizes = testCase.TestData.sizes;
disp('testing SolTriangularInferior');
for i = 1:length(sizes)
    %A = tril(rand(sizes(i)));
    %b = rand(sizes(i),1);
    [A,b] = generateWellCond(sizes(i),@(x) tril(forceWellCond(x)) );
    
    x = SolucaoTriangularInferior(A,b);
    gabx = gSolucaoTriangularInferior(A,b);
    
    abserr = max(abs(x - gabx));
    
    msg = [ 'absolute error is too big: ' num2str(abserr) char(10) ];
    msg = [ msg 'A: ' mat2str(A) char(10) ];
    msg = [ msg 'b: ' mat2str(b) char(10) ];
    msg = [ msg 'your    x: ' mat2str(x) char(10) ];
    msg = [ msg 'correct x: ' mat2str(gabx) char(10) ];
    assertLessThanOrEqual(testCase, abserr, testCase.TestData.tolerance, msg);
    
end%for
end%function


function testEliminacaoGauss(testCase)
sizes = testCase.TestData.sizes;
disp('testing EliminacaoGauss');
for i = 1:length(sizes)
    [A,b] = generateWellCond(sizes(i));
    
    [Aaluno, Baluno] = EliminacaoGauss(A,b);
    [gA,gB] = gEliminacaoGauss(A,b);
    
    abserrA = max(max(abs(Aaluno - gA)));
    abserrB = max(abs(Baluno - gB));
    
    msgA = [ 'absolute error is too big for A: ' num2str(abserrA) char(10) ];
    msgB = [ 'absolute error is too big for B: ' num2str(abserrB) char(10) ];
    msg = [ 'A: ' mat2str(A) char(10) ];
    msg = [ msg 'b: ' mat2str(b) char(10) ];
    msg = [ msg 'your    A: ' mat2str(Aaluno) char(10) ];
    msg = [ msg 'correct A: ' mat2str(gA) char(10) ];
    msg = [ msg 'your    B: ' mat2str(Baluno) char(10) ];
    msg = [ msg 'correct B: ' mat2str(gB) char(10) ];
    assertLessThanOrEqual(testCase, abserrA, testCase.TestData.tolerance, [msgA msg]);
    assertLessThanOrEqual(testCase, abserrB, testCase.TestData.tolerance, [msgB msg]);
    
end%for
end%function

function testDecomposicaoLU(testCase)
sizes = testCase.TestData.sizes;
disp('testing DecomposicaoLU');
for i = 1:length(sizes)
    [A,b] = generateWellCond(sizes(i));
    
    [La, Ua, Pa] = DecomposicaoLU(A);
    [gL, gU, gP] = gDecomposicaoLU(A);
    
    abserrL = max(max(abs(La - gL)));
    abserrU = max(max(abs(Ua - gU)));
    abserrP = max(max(abs(Pa - gP)));
    
    
    msgL = [ 'absolute error is too big for L: ' num2str(abserrL) char(10) ];
    msgU = [ 'absolute error is too big for U: ' num2str(abserrU) char(10) ];
    msgP = [ 'absolute error is too big for P: ' num2str(abserrP) char(10) ];
    msg = [ 'A: ' mat2str(A) char(10) ];
    msg = [ msg 'your    L: ' mat2str(La) char(10) ];
    msg = [ msg 'correct L: ' mat2str(gL) char(10) ];
    msg = [ msg 'your    U: ' mat2str(Ua) char(10) ];
    msg = [ msg 'correct U: ' mat2str(gU) char(10) ];
    msg = [ msg 'your    P: ' mat2str(Pa) char(10) ];
    msg = [ msg 'correct P: ' mat2str(gP) char(10) ];
    
    assertLessThanOrEqual(testCase, abserrL, testCase.TestData.tolerance, [msgL msg]);
    assertLessThanOrEqual(testCase, abserrU, testCase.TestData.tolerance, [msgU msg]);
    assertLessThanOrEqual(testCase, abserrP, testCase.TestData.tolerance, [msgP msg]);
    
end%for
end%function

function testSolucaoLU(testCase)
sizes = testCase.TestData.sizes;
disp('testing SolucaoLU');
for i = 1:length(sizes)
    [A,b] = generateWellCond(sizes(i));
    [L, U, P] = DecomposicaoLU(A);
    x = SolucaoLU(L,U,P,b);
    
    gabx = gSolucaoLU(L,U,P,b);
    
    abserr = max(abs(x - gabx));
    
    msg = [ 'absolute error is too big: ' num2str(abserr) char(10) ];
    msg = [ msg 'A: ' mat2str(A) char(10) ];
    msg = [ msg 'b: ' mat2str(b) char(10) ];
    msg = [ msg 'your    x: ' mat2str(x) char(10) ];
    msg = [ msg 'correct x: ' mat2str(gabx) char(10) ];
    assertLessThanOrEqual(testCase, abserr, testCase.TestData.tolerance, msg);
    
end%for
end%function

