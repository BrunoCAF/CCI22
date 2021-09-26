function ComparacaoPVC()
% Compara solucao numerica de PVC utilizando o PVC 
% y'' + 2 * y' + y = x, y(0) = 0, y(1) = -1, x em [0,1]

h = 0.02;
x = 0:h:1;
y0 = 0;
yn = -1;

g1 = @(x) 2;
g2 = @(x) 1;
r = @(x) x;

yNum = ProblemaValorContorno(g1, g2, r, x, y0, yn);
y = 2 .* exp(-x) .* (1-x) + x - 2;

figure;

plot(x,y, 'o-');
hold on;
plot(x,yNum, '*-r');
legend('Analitica', 'Numerica');
xlabel('x');
ylabel('y');
grid on;
title('Solucao de Problema de Valor de Contorno');

print -dpng -r400 comparapvc.png

h2 = 0.01;
x2 = 0:h2:1;
yNum2 = ProblemaValorContorno(g1, g2, r, x2, y0, yn);
y2 = 2 .* exp(-x2) .* (1-x2) + x2 - 2;

h3 = 0.005;
x3 = 0:h3:1;
yNum3 = ProblemaValorContorno(g1, g2, r, x3, y0, yn);
y3 = 2 .* exp(-x3) .* (1-x3) + x3 - 2;

legs = cell(1, 6);
legs{1} = 'Erro de h_1 = 0.02';
legs{2} = '(h_1)^2/12';
legs{3} = 'Erro de h_2 = 0.01';
legs{4} = '(h_2)^2/12';
legs{5} = 'Erro de h_3 = 0.005';
legs{6} = '(h_3)^2/12';

figure;
hold on;
plot(x, abs(y' - yNum));
plot(x, ((h^2)/12)*ones(size(x)));
plot(x2, abs(y2' - yNum2));
plot(x2, ((h2^2)/12)*ones(size(x2)));
plot(x3, abs(y3' - yNum3));
plot(x3, ((h3^2)/12)*ones(size(x3)));
legend(legs, 'FontSize', 8);
xlabel('x');
ylabel('|yAnal - yNum|');
grid on;
title('Análise do erro da solução numérica');

print -dpng -r400 comparapvcerro.png

end