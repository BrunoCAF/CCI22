function [I, x] = IntegracaoQuadraturaAdaptativa(f, a, b, epsilon)
% [I, x] = IntegracaoQuadraturaAdaptativa(f, a, b, epsilon): usando o 
% Metodo da Quadratura Adaptativa com Regra de Simpson, calcula uma 
% aproximacao para a integral:
%
% I = int_a^b f(x) dx
%
% As entradas sao a função f(x), os extremos do intervalo de integracao
% [a,b] e o erro total na integracao epsilon. As saidas sao o valor da 
% aproximacao da integral I e o vetor coluna x = [x_0,x_1,...,x_n]^T de 
% pontos que foram usados para calcular a integral.

y = f([a, (a+b)/2, b]);

[I, x, erro] = BissecQuadAdapt(f, a, b, b-a, epsilon, y(1), y(2), y(3));

[erro; epsilon];

end

function [I, x, erroparcial] = BissecQuadAdapt(f, xi, xf, L, epsilon, fa, fc, fb)

p = 4;
c = (xi+xf)/2;

xq = [xi; (xi+c)/2; c; (c+xf)/2; xf];
yp = [fa; fc; fb];
y = f([xq(2) xq(4)]);
yq = [yp(1); y(1); yp(2); y(2); yp(3)];

P = IntegracaoSimpson((xf-xi)/2, yp);
Q = IntegracaoSimpson((xf-xi)/4, yq);

if abs(P-Q) < epsilon*(2^p - 1)*(xf - xi)/L
    I = Q;
    x = xq;
    erroparcial = abs(P-Q)/(2^p - 1);
else
    [I1, x1, e1] = BissecQuadAdapt(f, xi, c, L, epsilon, yq(1), yq(2), yq(3));
    [I2, x2, e2] = BissecQuadAdapt(f, c, xf, L, epsilon, yq(3), yq(4), yq(5));
    I = I1 + I2;
    x = [x1; x2(2:end)];
    erroparcial = e1 + e2;
end

end
