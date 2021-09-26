clear;
load('analise1.mat');

%Métodos de Potências
[v1, l1] = MetodoPotencias(analise1.A1);
[v1inv, l1inv] = MetodoPotencias(inv(analise1.A1));
l1inv = 1/l1inv;

[v2, l2] = MetodoPotencias(analise1.A2);
[v2inv, l2inv] = MetodoPotencias(inv(analise1.A2));
l2inv = 1/l2inv;

[v3, l3] = MetodoPotencias(analise1.A3);
[v3inv, l3inv] = MetodoPotencias(inv(analise1.A3));
l3inv = 1/l3inv;

[v4, l4] = MetodoPotencias(analise1.A4);
[v4inv, l4inv] = MetodoPotencias(inv(analise1.A4));
l4inv = 1/l4inv;

[v5, l5] = MetodoPotencias(analise1.A5);
[v5inv, l5inv] = MetodoPotencias(inv(analise1.A5));
l5inv = 1/l5inv;

[v6, l6] = MetodoPotencias(analise1.A6);
[v6inv, l6inv] = MetodoPotencias(inv(analise1.A6));
l6inv = 1/l6inv;

%Método de Jacobi
%Matrizes simétricas: A3, A4 e A6
[V3, D3] = MetodoJacobi(analise1.A3);
[V4, D4] = MetodoJacobi(analise1.A4);
[V6, D6] = MetodoJacobi(analise1.A6);

%Algoritmo QR
sigma1 = diag(AlgoritmoQR(analise1.A1));
sigma2 = diag(AlgoritmoQR(analise1.A2));
sigma3 = diag(AlgoritmoQR(analise1.A3));
sigma4 = diag(AlgoritmoQR(analise1.A4));
sigma5 = diag(AlgoritmoQR(analise1.A5));
sigma6 = diag(AlgoritmoQR(analise1.A6));

%Matriz Companheira e Raízes do Polinômio
p = [14, 119, 282, 127, -101, -72, -9];
raizes = sort(diag(AlgoritmoQR(compan(p), 1e-15, 1e+15)));
raizesmesmo = sort(roots(p));

compararaizes = max(abs(raizes-raizesmesmo));
comparapoly = [polyval(p, raizes), polyval(p, raizesmesmo)];

save('resultado1.mat');