% analisando resultados oscilatorios. 
% extraia os picos, e analise a frequencia e amplitude dos mesmos

clear all; close all;
x = 1:.02:10;
% f: amplitude aumenta com x^2 (quadratico), frequencia aumenta com x (linear)
f = @(x)(x.^2).*sin(x.*x);
y = f(x);

% funcao do matlab, encontra os picos 
[py, index_px] = findpeaks(y);
px = x(index_px);

% demostra a funcao findpeacks
figure; hold on; grid on;
plot(x,y,'-bx','LineWidth',3);
plot(px,py,'gs','LineWidth',3);
legend(func2str(f),'peaks');

% periodo eh a diferenca entre picos sucessivos
period = diff(px);

% grafico mostra que frequencia eh linear em x
figure; hold on; grid on;
plot(px(2:end),1./period,'-bx','LineWidth',3);
legend(['frequency of ' func2str(f)]);
title('erro aumenta: amostragem constante mas frequencia aumenta')

% grafico mostra que amplitude dos picos varia quadraticamente
figure; hold on; grid on;
plot(log(px),log(py),'-bx','LineWidth',3);
legend(['log of ' func2str(f)]);
xlabel('log ( peaks_x )'); ylabel('log ( peaks_y )');
title('line, slope = 2');
