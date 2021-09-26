x = (-1:3)';
y = [1 1 0 -1 -2]';


p1 = PolinomioInterpolador(x, y);

xq = -1:0.001:3;
T = TabelaDiferencasDivididas(x, y);
[yq, p2] = InterpolacaoFormaNewton(T(1, :), x, xq);

format long;
Pdiff = max(abs(p1 - p2));
Fdiff = max(abs(polyval(p1, xq) - polyval(p2, xq)));

hold on;
plot(xq, polyval(p1, xq), 'r-', 'LineWidth', 2);
plot(xq, yq, 'b--', 'LineWidth', 2);
plot(x, y, 'k*');
xlabel('x');
ylabel('y = f(x)');
title('Comparação da Interpolação na forma de Lagrange vs. forma de Newton');
legend('Forma de Lagrange', 'Forma de Newton');
grid on;

print -dpng -r400 interpoldemo.png;