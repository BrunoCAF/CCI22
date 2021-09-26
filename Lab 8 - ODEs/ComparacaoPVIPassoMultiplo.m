function ComparacaoPVIPassoMultiplo()
% Compara metodos de passo multiplo utilizando a solucao do PVI
% y'' + y = 0, [y(0), y'(0)] = [1, 1]

h = 0.05;
x = 0:h:100;
y0 = [1, 1];

f = @(x,y) [y(2), -y(1)];

yAB4 = PVIAdamsBashforth4(f, x, y0);
yPC4 = PVIPrevisorCorretor4(f, x, y0);

y = [(cos(x) + sin(x))', (-sin(x) + cos(x))'];

eAB4 = abs(y - yAB4);
ePC4 = abs(y - yPC4);
figure;
semilogy(x, eAB4(:,1));
hold on;
semilogy(x, ePC4(:,1), 'r');
title('Comparacao entre metodos de passo multiplo');
xlabel('x');
ylabel('e');
legend('AB4', 'PC4');
grid on;

print -dpng -r400 comparapvipassomultiplo.png

end