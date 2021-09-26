%Definindo as funcoes objetivo
f1 = @(x) (x.^3 - x.^2 + 10*x - 5);
df1 = @(x) (3*x.^2 - 2*x + 10);
f2 = @(x) (exp(-(x.^2)) - cos(x));
df2 = @(x) (-2*x.*exp(-(x.^2)) + sin(x));

%Definindo as funcoes de iteracao
g1 = @(x) ((5 - x.^3 + x.^2)/10);
g2 = @(x) (x - f2(x));

%Definindo intervalos
a1 = 0; b1 = 1;
a2 = 1; b2 = 2;

%Definindo Hiperparametros
epsilon = 10^-4;
maxIteracoes = 1000;

%Coletando dados para a funcao 1:
[rbis, nbis] = Bisseccao(f1, a1, b1, epsilon, maxIteracoes);
[rposf, nposf] = PosicaoFalsa(f1, a1, b1, epsilon, maxIteracoes);

[rpfix, npfix] = PontoFixo(f1, g1, (a1+b1)/2, epsilon, maxIteracoes);

[rnr, nnr] = NewtonRaphson(f1, df1, (a1+b1)/2, epsilon, maxIteracoes);

[rsec, nsec] = Secante(f1, a1, b1, epsilon, maxIteracoes);

opt = optimset('MaxIter', maxIteracoes, 'TolFun', epsilon);
[rfz, frfz, flag, saida] = fzero(f1, [a1, b1], opt);
nfz = saida.iterations;

f1data = [
    nbis, nposf, npfix, nnr, nsec, nfz; 
    rbis, rposf, rpfix, rnr, rsec, rfz;
    f1([rbis, rposf, rpfix, rnr, rsec, rfz])];

%Coletando dados para a funcao 2:
[rbis, nbis] = Bisseccao(f2, a2, b2, epsilon, maxIteracoes);
[rposf, nposf] = PosicaoFalsa(f2, a2, b2, epsilon, maxIteracoes);

[rpfix, npfix] = PontoFixo(f2, g2, (a2+b2)/2, epsilon, maxIteracoes);

[rnr, nnr] = NewtonRaphson(f2, df2, (a2+b2)/2, epsilon, maxIteracoes);

[rsec, nsec] = Secante(f2, a2, b2, epsilon, maxIteracoes);

opt = optimset('MaxIter', maxIteracoes, 'TolFun', epsilon);
[rfz, frfz, flag, saida] = fzero(f2, [a2, b2], opt);
nfz = saida.iterations;

f2data = [
    nbis, nposf, npfix, nnr, nsec, nfz; 
    rbis, rposf, rpfix, rnr, rsec, rfz;
    f2([rbis, rposf, rpfix, rnr, rsec, rfz])];


