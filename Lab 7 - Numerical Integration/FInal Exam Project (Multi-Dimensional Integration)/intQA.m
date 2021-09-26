function [I, x] = intQA(f, a, b, epsilon)

if a == b
    I = 0;
    x = [];
else
    y = [f(a); f((a+b)/2); f(b)];
    [I, x] = BissecQuadAdapt(f, a, b, b-a, epsilon, y);
end

end

function [I, x] = BissecQuadAdapt(f, xi, xf, L, epsilon, fval)

if xi == xf
    I = 0;
    x = [];
else

p = 4;
c = (xi+xf)/2;

xq = [xi; (xi+c)/2; c; (c+xf)/2; xf];
yp = fval;
y = [f(xq(2)); f(xq(4))];
yq = [yp(1); y(1); yp(2); y(2); yp(3)];

P = IntegracaoSimpson((xf-xi)/2, yp);
Q = IntegracaoSimpson((xf-xi)/4, yq);

if abs(P-Q) < epsilon*(2^p - 1)*(xf - xi)/L
    I = Q;
    x = xq;
else
    [I1, x1] = BissecQuadAdapt(f, xi, c, L, epsilon, yq(1:3));
    [I2, x2] = BissecQuadAdapt(f, c, xf, L, epsilon, yq(3:5));
    I = I1 + I2;
    x = [x1; x2(2:end)];
end

end

end
