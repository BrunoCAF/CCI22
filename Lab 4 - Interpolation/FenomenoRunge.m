% Estilos usados para plotar diferentes curvas no mesmo graficos
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
title('Fenomeno de Runge para a funcao f(x) = 1/(1 + 25x^2)');
grid on;
hold on;

% legs guarda as legendas das curvas f(x),p_1(x),p_2(x),...,p_16(x)
legs = cell(0);
legs{1} = 'f(x)';

% Vamos usar N=2^0,2^1,2^2,2^3,2^4
for i=0:4
    n = 2^i;
    
    % Igualmente espacado com n divisoes (e n+1 pontos)
    h = (b - a) / n;
    x = (a:h:b)';
    y = f(x);
    T = TabelaDiferencasDivididas(x, y);
    yq = InterpolacaoFormaNewton(T(1,:), x, xq);
    
    plot(xq, yq, estilos{i+2});
    legs{i+2} = sprintf('p_{%d}(x)', n);
end

legend(legs);

print -dpng -r400 rungedemo.png;

figure;

maxN = 20;
eMax = zeros(maxN, 1);
% Calcula max|f(x) - p_N(x)|, com x no intervalo [-1,1]
for N=1:maxN
    h = (b - a) / N;
    x = (a:h:b)';
    y = f(x);
    T = TabelaDiferencasDivididas(x, y);
    yq = InterpolacaoFormaNewton(T(1,:), x, xq);
    
    eMax(N) = max(abs(f(xq) - yq));
end

% Encontra o minimo dos eMax's
[minEMax, indexMinEMax] = min(eMax);

% Plota grafico de como varia E(n) com n
plot(1:maxN, eMax);
hold on;
plot(indexMinEMax, minEMax, 'r*');
ylabel('max(|f(x)-p_n(x)|)');
xlabel('n (grau do polinomio interpolador)');
title(sprintf('max(|f(x) - p_n(x)|) no intervalo [%g,%g]', a,b));
grid on;

print -dpng -r400 errorunge.png;