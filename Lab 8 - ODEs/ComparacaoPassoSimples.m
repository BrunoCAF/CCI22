function ComparacaoPassoSimples()
% Compara metodos de passo simples utilizando a solucao do PVI
% y'' + y = 0, [y(0), y'(0)] = [1, 1]

h = 0.05;
x = 0:h:100;
y0 = [1, 1];

f = @(x,y) [y(2), -y(1)];

yEuler = PVIEuler(f, x, y0);
yHeun = PVIHeun(f, x, y0);
yRK4 = PVIRungeKutta4(f, x, y0);

y = [(cos(x) + sin(x))', (-sin(x) + cos(x))'];

eEuler = abs(y - yEuler);
eHeun = abs(y - yHeun);
eRK4 = abs(y - yRK4);
semilogy(x, eEuler(:,1));
hold on;
semilogy(x, eHeun(:,1), 'r');
semilogy(x, eRK4(:,1), 'g');
title('Comparacao entre metodos de passo simples');
xlabel('x');
ylabel('e');
legend('Euler', 'Heun', 'RK4');
grid on;

print -dpng -r400 comparapassosimples.png;

end