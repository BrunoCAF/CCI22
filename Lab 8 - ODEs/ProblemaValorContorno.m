function y = ProblemaValorContorno(g1, g2, r, x, y0, yn)
% y = ProblemaValorContorno(g1, g2, r, x, y0, yn) resolve numericamente um 
% problema de valor de contorno (PVC) da seguinte forma:
%
% y''(x) + g_1(x) y'(x) + g_2(x) y(x) = r(x), y(a) = y_0, y(b) = y_n, 
% x em [a,b]
%
% O PVC eh resolvido nos pontos igualmente espacados do vetor 
% x = [x_0,x_1,...,x_n]^T, em que h = x_{i+1} - x_i,i=0,1,2,...,n-1. 
% Utiliza-se esquemas de diferencas centradas para aproximar as derivadas:
%
% y''(x) = (y_{i+1} - 2 y_i + y_{i-1}) / h^2
%
% y'(x) = (y_{i+1} - y_{i-1}) / (2 * h)

h = x(2) - x(1);
n = length(x) - 1;

a = zeros(n-1, 1);
b = zeros(n-1, 1);
c = zeros(n-1, 1);
d = zeros(n-1, 1);

for i=1:(n-1)
    % Montar sistema tridiagonal
    a(i) = 1 - g1(x(i+1))*h/2;
    b(i) = -2 + g2(x(i+1))*h^2;
    c(i) = 1 + g1(x(i+1))*h/2;
    d(i) = r(x(i+1))*h^2;
end

d(1) = d(1) - a(1)*y0;
d(n-1) = d(n-1) - c(n-1)*yn;

% Solucionar sistema tridiagonal
y = SolucaoTridiagonal(a, b, c, d);

% Incluir condicoes de contorno na solucao
y = [y0; y; yn];

end