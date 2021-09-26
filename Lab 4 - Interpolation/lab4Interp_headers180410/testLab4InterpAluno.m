function tests = testLab4InterpAluno
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)  % do not change function name
sizes = [2:10 2:10];
testCase.TestData.sizes = sizes;
testCase.TestData.tolerance = 1e-6;
testCase.TestData.maxCond = 1e7;
ncase=0;
for n=sizes
    ncase=ncase+1;
    accept_case = false;
    while (~accept_case)
        x = 20*rand(n,1)-10;
        y = 20*rand(n,1)-10;
        x = sort(x);
        % POLinomio Interpolador
        [p,cA] = gPolinomioInterpolador(x, y,testCase.TestData.maxCond);
        accept_case = (cA < testCase.TestData.maxCond);
    end
    
    testCase.TestData.tcases(ncase).x=x;
    testCase.TestData.tcases(ncase).y=y;    
    testCase.TestData.tcases(ncase).p = p;
    testCase.TestData.tcases(ncase).cA = cA;
    
    % Newton
    xq = (x(1):0.1:x(end))';
    T = gTabelaDiferencasDivididas(x, y);
    dd = T(1,:);
    [yq, ipoly] = gInterpolacaoFormaNewton(dd, x, xq);
    testCase.TestData.tcases(ncase).dd = dd;
    testCase.TestData.tcases(ncase).xq = xq;
    testCase.TestData.tcases(ncase).yq = yq;
    testCase.TestData.tcases(ncase).ipoly = ipoly;
    testCase.TestData.tcases(ncase).T = T;
end%for

bigsizes = [10 100:50:500];
testCase.TestData.bigsizes = bigsizes;
ncase=0;
for n=bigsizes
    ncase=ncase+1;
    x = 200*rand(n,1)-100;
    y = 200*rand(n,1)-100;
    x = sort(x);
    y = sort(y);
    testCase.TestData.bcases(ncase).x=x;% nos de interpolacao
    testCase.TestData.bcases(ncase).y=y;% nos de interpolacao
    % SistemaSpilinecubica
    [a, b, c, d] = gSistemaSplineCubica(x, y);
    testCase.TestData.bcases(ncase).a = a;
    testCase.TestData.bcases(ncase).b = b;
    testCase.TestData.bcases(ncase).c = c;
    testCase.TestData.bcases(ncase).d = d;
    % Solucaotridiagonal
    x3d = gSolucaoTridiagonal(a, b, c, d);
    testCase.TestData.bcases(ncase).x3d = x3d;
    % Interp Spline cubica
    xq = linspace(x(1),x(end),n);
    yq = gInterpolacaoSplineCubica(x, y, xq);
    testCase.TestData.bcases(ncase).xq = xq;
    testCase.TestData.bcases(ncase).yq = yq;
end%for


end%setupOnce

function teardownOnce(testCase)  % do not change function name
end

function setup(testCase)    % do not change function name
end

function teardown(testCase) % do not change function name
end

function testPolinInterp(testCase)
sizes = testCase.TestData.sizes;
disp('testing PolinomioInterpolador');
for i = 1:length(sizes)
    x =  testCase.TestData.tcases(i).x;
    y =  testCase.TestData.tcases(i).y;
    gab_p = testCase.TestData.tcases(i).p;
    
    aluno_p = PolinomioInterpolador(x, y,testCase.TestData.maxCond);
    
    assertSizeEqual(testCase,gab_p,aluno_p);
       
    msg = [ 'x= ' mat2str(x) char(10) ];
    msg = [ msg 'y= ' mat2str(y) char(10) ];
    assertAbsDiff(testCase,aluno_p,gab_p,testCase.TestData.tolerance,msg);
    
end%for
end%function

function testTabDifDiv(testCase)
sizes = testCase.TestData.sizes;
disp('testing TabelaDiferencasDividas');
for i = 1:length(sizes)
    x =  testCase.TestData.tcases(i).x;
    y =  testCase.TestData.tcases(i).y;
    gab_T = testCase.TestData.tcases(i).T;
    
    aluno_T = TabelaDiferencasDivididas(x, y);
    assertSizeEqual(testCase,gab_T,aluno_T);
    
    msg = [ 'x= ' mat2str(x) char(10) ];
    msg = [ msg 'y= ' mat2str(y) char(10) ];
    assertAbsDiff(testCase,aluno_T,gab_T,testCase.TestData.tolerance,msg);
    
end%for
end%function


function testNewtonInterp(testCase)
sizes = testCase.TestData.sizes;
disp('testing InterpolacaoFormaNewton');
for i = 1:length(sizes)
    x =  testCase.TestData.tcases(i).x;
    xq =  testCase.TestData.tcases(i).xq;
    dd = testCase.TestData.tcases(i).dd;
    gab_yq = testCase.TestData.tcases(i).yq;
    gab_ip = testCase.TestData.tcases(i).ipoly;
    
    [aluno_yq, aluno_ip] = InterpolacaoFormaNewton(dd, x, xq);
    assertSizeEqual(testCase,gab_yq,aluno_yq);
    
    common_msg = [ 'x= ' mat2str(x) char(10) ];
    common_msg = [ common_msg 'xq= ' mat2str(xq) char(10) ];
    common_msg = [ common_msg 'dd= ' mat2str(dd) char(10) ];
    
    msg = [ 'Testing if the interpolated values are ok' char(10) ];
    msg = [ msg common_msg ];
    assertAbsDiff(testCase,aluno_yq,gab_yq,testCase.TestData.tolerance,msg);
    
    aluno_yq_fromIpoly = polyval(aluno_ip,xq);% aplica o polinomio
    msg = [ 'Testing if polyval(aluno_ipoly,xq) == yq' char(10) ];
    msg = [ msg 'aluno_ipoly= ' mat2str(aluno_ip) char(10) ];
    msg = [ msg common_msg ];
    assertAbsDiff(testCase,aluno_yq_fromIpoly,gab_yq,testCase.TestData.tolerance,msg);
    
    msg = [ 'Testing if the polynomial is itself correct' char(10) ];
    msg = [ msg common_msg ];
    assertAbsDiff(testCase,aluno_ip,gab_ip,testCase.TestData.tolerance,msg);
    
    
end%for
end%function


function testSistSplineCubic(testCase)

bigsizes = testCase.TestData.bigsizes;
disp('testing sistemaSplineCubica');
for i = 1:length(bigsizes)
    x =  testCase.TestData.bcases(i).x;
    y =  testCase.TestData.bcases(i).y;
    gab_a =  testCase.TestData.bcases(i).a;
    gab_b =  testCase.TestData.bcases(i).b;
    gab_c =  testCase.TestData.bcases(i).c;
    gab_d =  testCase.TestData.bcases(i).d;
    
    [aluno_a, aluno_b, aluno_c, aluno_d] = SistemaSplineCubica(x, y);
    assertSizeEqual(testCase,gab_a,aluno_a);
    assertSizeEqual(testCase,gab_b,aluno_b);
    assertSizeEqual(testCase,gab_c,aluno_c);
    assertSizeEqual(testCase,gab_d,aluno_d);
    
    msg = [ 'x= ' mat2str(x) char(10) ];
    msg = [ msg 'y= ' mat2str(y) char(10) ];
    assertAbsDiff(testCase,aluno_a,gab_a,testCase.TestData.tolerance,msg);
    assertAbsDiff(testCase,aluno_b,gab_b,testCase.TestData.tolerance,msg);
    assertAbsDiff(testCase,aluno_c,gab_c,testCase.TestData.tolerance,msg);
    assertAbsDiff(testCase,aluno_d,gab_d,testCase.TestData.tolerance,msg);
    
    
end%for
end%function


function testSolucaoTridiagonal(testCase)

bigsizes = testCase.TestData.bigsizes;
disp('testing SolucaoTridiagonal');
for i = 1:length(bigsizes)
    a =  testCase.TestData.bcases(i).a;
    b =  testCase.TestData.bcases(i).b;
    c =  testCase.TestData.bcases(i).c;
    d =  testCase.TestData.bcases(i).d;
    gab_x3d = testCase.TestData.bcases(i).x3d;
    
    aluno_x3d = SolucaoTridiagonal(a, b, c, d);
    
    assertSizeEqual(testCase,gab_x3d,aluno_x3d);
    
    msg = [ 'a= ' mat2str(a) char(10) ];
    msg = [ msg 'b= ' mat2str(b) char(10) ];
    msg = [ msg 'c= ' mat2str(c) char(10) ];
    msg = [ msg 'd= ' mat2str(d) char(10) ];
    assertAbsDiff(testCase,aluno_x3d,gab_x3d,testCase.TestData.tolerance,msg);
    
end%for
end%function



function testInterpSplineCubica(testCase)
bigsizes = testCase.TestData.bigsizes;
disp('testing InterpolacaoSpilineCubica');
for i = 1:length(bigsizes)
    x =  testCase.TestData.bcases(i).x;
    y =  testCase.TestData.bcases(i).y;
    xq =  testCase.TestData.bcases(i).xq;
    gab_yq = testCase.TestData.bcases(i).yq;
    
    aluno_yq = InterpolacaoSplineCubica(x, y, xq);
    assertSizeEqual(testCase,gab_yq,aluno_yq);   
    
    msg = [ 'x= ' mat2str(x) char(10) ];
    msg = [ msg 'y= ' mat2str(y) char(10) ];
    msg = [ msg 'xq= ' mat2str(xq) char(10) ];
  
    assertAbsDiff(testCase,aluno_yq,gab_yq,testCase.TestData.tolerance,msg);
    
    
end%for
end%function
