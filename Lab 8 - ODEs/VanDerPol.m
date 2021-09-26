function VanDerPol()
% Traça gráficos de soluções do oscilador de Van de Pol para diferentes
% condições iniciais

mu = 1;
y0 = [-2 -2; -2 2; -1 -1; 1 1; 2 2; 2 -2];

colors = {'b', 'g', 'r', 'c', 'm', 'k'};

h = 0.01;
x = (0:h:1000)';

f = @(x,y) [y(2), mu * (1 - y(1)^2) * y(2) - y(1)];

figure;
hold on;
ni = size(y0, 1);
legs = cell(ni, 1);
for i=1:ni
    y = PVIRungeKutta4(f, x, y0(i,:));
    plot(y(500:end,1), y(500:end,2), colors{i});
    legs{i} = sprintf('y0 = [%d %d]', y0(i,1), y0(i,2));
end

title('Retrato de Fase - Oscilador Van der Pol (regime estacionário)');
xlabel('y');
ylabel('y''');
legend(legs);
grid on;

print -dpng -r400 vanderpol2.png;

end
