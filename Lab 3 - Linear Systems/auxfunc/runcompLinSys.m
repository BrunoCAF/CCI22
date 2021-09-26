
solucoes = {@SolucaoGauss,@SolucaoLUCompleta,@GaussJacobi,@GaussSeidel}

% cenario 1: 10 testes com matrizes aleatorias de tamanho 50.
compLinSysTimes(10,50,solucoes,@generateSassenfeldOk);

% cenario 2: 5 testes com matrizes esparsas de tamanho 1000.
compLinSysTimes(5,1000,solucoes,@genSpSassenfeldOk);

% cenario 3: 3 testes com matrizes de hilbert de tamanho 6,7,8
compLinSysTimesHilbert(6:8,solucoes);
