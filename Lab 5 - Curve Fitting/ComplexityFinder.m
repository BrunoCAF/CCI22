for x = 0:10:100
    fmagicexp(x);
end
%Medida inicial para descartar ruídos devido ao carregamento das variáveis,
%etc

%Comportamento exponencial começa a se pronunciar por volta de x = 300
time = zeros(size(300:10:1700));
%Limite superior de 1700 pra não demorar demais
i = 1;

for x = 300:10:1700
    for k = 1:10 %Faz-se a média de 10 medidas para reduzir o erro
        tic;
        fmagicexp(x);
        time(i) = time(i) + toc;
    end
    time(i) = time(i)/10;
    i = i+1;
end

x = 300:10:1700;

%Aplicando os minimos quadrados com o truque do ln
T = log(time);

Phi{1} = @(x)(1); Phi{2} = @(x)(log(x));
c = MinimosQuadrados(Phi', x', T');
beta = exp(c(1));
alpha = c(2);

figure;
hold on;
plot(x, time, 'r');%Plotando os dados experimentais juntamente com a curva
plot(x, (x.^(alpha))*beta, 'b');%já ajustada
xlabel('Tamanho da entrada');
ylabel('Tempo (s)');
legend('Curva Experimental', 'Curva de ajuste', 'Location', 'north');
title('Complexidade da função fmagicexp');
grid on;
grid minor;
axis fill;

print -dpng -r400 complexityfit1.png;

figure;
hold on;
normaltime = time.^(1/alpha);
[linecoef, r] = RegressaoLinear(x', normaltime');
lineeq = @(x)(linecoef(1) + x.*linecoef(2));
plot(x, normaltime, 'k');%Plotando os dados experimentais "linearizados"
plot(x, lineeq(x), 'g');%Junto com a equação da reta de ajuste
xlabel('Tamanho da entrada');
ylabel('Tempo \^ (1/alpha)');
legend('Curva Experimental', sprintf('y = %gx + %g', linecoef(2), linecoef(1)), 'Location', 'northwest');
title(sprintf('Complexidade da função fmagicexp - (r = %g)', r));
grid on;
grid minor;
axis fill;

print -dpng -r400 complexityfit2.png;

%3.163564094318316 = alpha
%0.000000000027215 = beta
%0.999690089646124 = r
%0.000453826014891 = a
%0.003394778152612 = b