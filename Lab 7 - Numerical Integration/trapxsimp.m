f = @(x) (x.*exp(x.^2));

a = 1; b = 2;

I1Trap = zeros(50,1);
I1Simp = zeros(50,1);

I1 = ones(50,1)*(exp(4) - exp(1))/2;

for n = 2:2:100
    h = (b-a)/n;
    y = f(a:h:b);
    I1Trap(n/2) = IntegracaoTrapezio(h, y');
    I1Simp(n/2) = IntegracaoSimpson(h, y');
end

n = 2:2:100;

figure;
hold on;
plot(n, I1Trap, 'r');
plot(n, I1Simp, 'b');
plot(n, I1, 'k--');
xlabel('N�mero de subintervalos');
ylabel('Valor da Integral');
legend('M�todo do Trap�zio', 'M�todo de Simpson 1/3', 'Valor Exato', 'Location', 'north');
title('Evolu��o do valor da integral em fun��o do refinamento');
grid on;
grid minor;
axis fill;

print -dpng -r400 errosintegracao.png;

figure;
hold on;
plot(n, -log10(I1Trap - I1), 'r');
plot(n, -log10(I1Simp - I1), 'b');
xlabel('N�mero de subintervalos');
ylabel('-log10(IAprox - IExato) | # de casas decimais corretas');
legend('M�todo do Trap�zio', 'M�todo de Simpson 1/3', 'Location', 'northwest');
title('Aproxima��o do valor exato em fun��o do refinamento');
grid on;
grid minor;
axis tight;

print -dpng -r400 errosintegracaozoom.png;


f = @(x) (0.5 - 0.02*(x.^2) + exp(-(x-1).^2).*(sin(pi.*x).^2));

eps = 1e-4;
[~, x] = IntegracaoQuadraturaAdaptativa(f, -5, 5, eps);

h = 0.01;

figure;
hold on;
plot(-5:h:5, f(-5:h:5), 'b', 'LineWidth', 2);
plot(x, f(x), 'r*');
line([x'; x'], [zeros(size(x')) - 0.4; ones(size(x')) + 0.4], 'Color', 'y');
xlabel('Pontos da quadratura adaptativa');
ylabel('f(x) = 0.5 - 0.02x^2 + exp(-(x-1)^2)*sin^2(pi*x)');
title('Quadratura adaptativa');
grid on;
axis fill;

print -dpng -r400 quadadapt.png;
