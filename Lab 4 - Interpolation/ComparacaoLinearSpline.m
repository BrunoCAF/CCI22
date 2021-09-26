% Estilos usados para plotar diferentes curvas no mesmo grafico
estilos = {'b-', 'g-', 'r-', 'c-', 'm-', 'k-', 'y-'};

f = @(x) (1 ./ (1 + 25 * x.^2));
% a e b sao extremos do intervalo
a = -1;
b = 1;

% dt eh o passo usado para o plot
dt = 0.001;
xq = (a:dt:b)';
yq = f(xq);

% Plota o grafico de f(x)
plot(xq, yq, estilos{1});
xlabel('x');
ylabel('y = f(x)');
title('Interpolacao linear para f(x) = 1 / (1 + 25 * x^2)');
grid on;
hold on;

legs = cell(0);
legs{1} = 'f(x)';

% Vamos usar N = 2^1,2^2,2^3,2^4
for i = 1:4
    n = 2^i;
    
    % Igualmente espaçado com n divisoes (e n+1 pontos)
    h = (b - a) / n;
    x = (a:h:b)';
    y = f(x);
    yq = InterpolacaoLinear(x, y, xq);
    
    plot(xq, yq, estilos{i+1});
    legs{i+1} = sprintf('n = %d', n);
end

legend(legs);

print -dpng -r400 interplinear.png;

figure;

yq = f(xq);

% Plota o gráfico de f(x)
plot(xq, yq, estilos{1});
xlabel('x');
ylabel('y = f(x)');
title('Interpolacao por Spline Cubica para a função f(x) = 1 / (1 + x^2)');
grid on;
hold on;

legs = cell(0);
legs{1} = 'f(x)';

% Vamos usar N = 2^1,2^2,2^3,2^4
for i = 1:4
    n = 2^i;
    
    % Igualmente espacado com n divisoes (e n+1 pontos)
    h = (b - a) / n;
    x = (a:h:b)';
    y = f(x);
    yq = InterpolacaoSplineCubica(x, y, xq);
    
    plot(xq, yq, estilos{i+1});
    legs{i+1} = sprintf('n = %d', n);
end

legend(legs);

print -dpng -r400 interpspline.png;

figure;

maxN = 50;
eMax = zeros(maxN, 1);
% Calcula max|f(x) - p(x)|, com x no intervalo [-1,1]
for N = 2:maxN
    h = (b - a) / N;
    x = (a:h:b)';
    y = f(x);
    yq = InterpolacaoLinear(x, y, xq);
    
    eMax(N) = max(abs(f(xq) - yq));
end

% Plota grafico de como varia E(n) com n
plot(2:maxN, eMax(2:maxN));
hold on;

maxN = 50;
eMax = zeros(maxN, 1);
% Calcula max|f(x) - p(x)|, com x no intervalo [-1,1]
for N = 2:maxN
    h = (b - a) / N;
    x = (a:h:b)';
    y = f(x);
    yq = InterpolacaoSplineCubica(x, y, xq);
    
    eMax(N) = max(abs(f(xq) - yq));
end

% Plota grafico de como varia E(n) com n
plot(2:maxN, eMax(2:maxN), 'r');
title(sprintf('max(|f(x) - p(x)|) no intervalo [%g,%g]', a,b));
ylabel('max(|f(x) - p(x)|)');
xlabel('n');
legend('Linear', 'Spline Cubica');
grid on;

print -dpng -r400 comparainterp.png;