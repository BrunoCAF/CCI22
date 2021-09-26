%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parte 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % A primeira análise que podemos fazer é comparar o método de Monte Carlo
% % simples com sua variante quasi-aleatória. Para isso, vamos considerar uma
% % determinada integral e calculá-la com diferentes quantidade de iterações,
% % usando a geração de números aleatórios simples, a sequência de Halton e a
% % sequência de Sobol. 
% 
% % Vamos integrar a função gaussiana em 3D, f(x,y,z) = exp(-(x^2+y^2+z^2)),
% % na região cúbica de [-1, 1]^3. 
% f = @(x) exp(-sum(x.^2));
% boxlb = [-1;-1;-1]; boxub = -boxlb;
% chi = @(x) (boxlb <= x).*(x <= boxub);
% 
% % Vamos usar como valor de referência a resposta da rotina integral3,
% % nativa do MATLAB, que serve para calcular integrais triplas. 
% IntReferencia = integral3(@(x,y,z) exp(-(x.^2 + y.^2 + z.^2)), -1, 1, -1, 1, -1, 1);
% 
% % Vamos variar a quantidade de iterações de 1e3 em 1e3 até 1e5
% QtdIter = 1e3:1e3:1e5;
% 
% % E armazenar os valores das integrais
% med_MC = zeros(size(QtdIter')); 
% dev_MC = med_MC;
% 
% med_QMCH = zeros(size(QtdIter')); 
% dev_QMCH = med_QMCH;
% 
% med_QMCS = zeros(size(QtdIter')); 
% dev_QMCS = med_QMCS;
% 
% for i = 1:length(QtdIter)
%     [med_MC(i), dev_MC(i), ~] = intmontecarlo(f, chi, boxlb, boxub, 'numIter', QtdIter(i), 'shuffle');
%     [med_QMCH(i), dev_QMCH(i), ~] = intmontecarlo(f, chi, boxlb, boxub, 'numIter', QtdIter(i), 'halton');
%     [med_QMCS(i), dev_QMCS(i), ~] = intmontecarlo(f, chi, boxlb, boxub, 'numIter', QtdIter(i), 'sobol');
% end
% 
% 
% % Gráfico da comparação do valor da integral
% figure; hold on;
% plot(QtdIter, IntReferencia*ones(size(QtdIter)), 'k-');
% plot(QtdIter, med_MC, 'r-');
% plot(QtdIter, med_QMCH, 'g-');
% plot(QtdIter, med_QMCS, 'b-');
% 
% plot(QtdIter, med_MC - dev_MC, 'r-.');
% plot(QtdIter, med_MC + dev_MC, 'r-.');
% plot(QtdIter, med_QMCH - dev_QMCH, 'g-.');
% plot(QtdIter, med_QMCH + dev_QMCH, 'g-.');
% plot(QtdIter, med_QMCS - dev_QMCS, 'b-.');
% plot(QtdIter, med_QMCS + dev_QMCS, 'b-.');
% legend('Valor Exato', 'MC', 'QMCH', 'QMCS');
% xlabel('Quantidade de iterações'); ylabel('Valor da Integral');
% title('Comparação entre MC simples e Quasi-MC');
% grid minor; axis fill;
% print -dpng -r400 figura7.png;
% 
% % Gráfico dos erros absolutos
% figure; hold on;
% plot(QtdIter, abs(med_MC - IntReferencia), 'r-');
% plot(QtdIter, abs(med_QMCH - IntReferencia), 'g-');
% plot(QtdIter, abs(med_QMCS - IntReferencia), 'b-');
% legend('MC', 'QMCH', 'QMCS');
% xlabel('Quantidade de iterações'); ylabel('Erro da integral');
% title('Comparação entre MC simples e Quasi-MC');
% grid minor; axis fill;
% print -dpng -r400 figura8.png;
% 
% % Gráfico dos desvios padrão
% figure; hold on;
% plot(QtdIter, dev_MC, 'r-.');
% plot(QtdIter, dev_QMCH, 'g-.');
% plot(QtdIter, dev_QMCS, 'b-.');
% legend('MC', 'QMCH', 'QMCS');
% xlabel('Quantidade de iterações'); ylabel('Desvio Padrão');
% title('Comparação entre MC simples e Quasi-MC');
% grid minor; axis fill;
% print -dpng -r400 figura9.png;
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parte 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% A segunda análise possível é comparar o método de Monte Carlo simples com
% suas variantes com amostragem antitética e amostragem estratificada. 
% 
% Vamos utilizar a função de Rastrigin 3D, por ser um exemplo de função com
% muita oscilação, e cuja integral analítica pode ser facilmente calculada.
% dim = 3; A = 10;
% fRastrigin = @(x) A*dim + sum(x.^2) - A*sum(cos(2*pi.*x));
% 
% Vamos integrá-la no cubo [-5, 5]^3, então seu valor exato será
% Iexata = (1e3)*A*dim + (1e2)*2*(5^3);
% 
% boxlb = [-5;-5;-5]; boxub = -boxlb; 
% chi = @(x) (boxlb <= x).*(x <= boxub); 
% 
% Vamos definir um requisito de tolerância
% relTol = 1e-2;
% 
% Vamos definir uma partição para a amostragem estratificada, de modo que
% favoreça a convergência do método. 
% P = [2;2;2];
% 
% [fmed_MC, fdev_MC, N_MC] = intmontecarlo(fRastrigin, chi, boxlb, boxub, 'relTol', relTol);
% [fmed_MCA, fdev_MCA, N_MCA] = intMCAnti(fRastrigin, chi, boxlb, boxub, 'relTol', relTol);
% [fmed_MCE, fdev_MCE, N_MCE] = intMCEstr(fRastrigin, chi, boxlb, boxub, P, relTol);
% 
% Agora comparamos os valores obtidos e as quantidade de pontos amostrados
% erro_MC  = abs(Iexata - fmed_MC );
% erro_MCA = abs(Iexata - fmed_MCA);
% erro_MCE = abs(Iexata - fmed_MCE);
% 
% Tabela com erros, desvios padrão e número de pontos. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parte 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% A terceira análise que podemos fazer é comparar o método de Monte Carlo
% com o método de integração iterada. Para tal, usaremos o mesmo problema
% de calcular o volume da bola unitária no Rn. 

% Medir tempo de execução para atingir 1e-3;
% Comparar os valores (média com o analítico) e variância;
% Comparar quantidade de pontos;

n = 5;
fmed = zeros(n,1); fdev = zeros(n,1); N = zeros(n,1);
temposMC = zeros(n,1);

f = @(x) 1;
chi = @(x) (norm(x) < 1);
boxub = ones(n, 1); boxlb = -boxub;

for dim = 1:n
    tic;
    [fmed(dim), fdev(dim), N(dim)] = intmontecarlo(f, chi, boxlb(1:dim), boxub(1:dim), 'relTol', 1e-2);
    temposMC(dim) = toc;
end

load('infobola.mat');
dim = (1:n)';
Ianalitica = ( pi.^(dim./2) ) ./ ( gamma(dim./2) .* (dim./2) );

% Tempos
figure; hold on;
plot(1:n, log10(tempos), '-bd');
plot(1:n, log10(temposMC), '-rd');
legend('intmult', 'MonteCarlo');
xlabel('Número de Dimensões'); ylabel('log10(Tempo de execução (s))');
title('Custo do cálculo do volume de B_n(1)');
grid minor;
axis fill;
print -dpng -r400 figura10.png;

% Valor da integral
figure; hold on;
plot(1:n, Ianalitica, 'b', 'LineWidth', 1.5); 
plot(1:n, fmed, 'r--', 'LineWidth', 1.5); 
legend('Valor Analítico', 'Valor Numérico via MC');
xlabel('Número de Dimensões'); ylabel('Valor da Integral');
title('Comparação entre a integral de Monte Carlo e o valor exato');
grid minor;
axis fill;
print -dpng -r400 figura11.png;

% Erro absoluto
figure; hold on;
plot(1:n, abs(I - Ianalitica), 'b');
plot(1:n, abs(fmed - Ianalitica), 'r');
plot(1:n, fdev, 'y-.');
legend('Erro intmult', 'Erro MC', 'Desvio padrão MC');
xlabel('Número de Dimensões'); 
ylabel('Erro absoluto |I_numerica - I_analitica|');
title('Erro absoluto da integração numérica');
grid minor;
axis fill;
print -dpng -r400 figura12.png;

% Qtd de pontos
figure; hold on;
plot(1:n, log10(qtdpontos), 'b-o');
plot(1:n, log10(N), 'r-o');
xlabel('Número de Dimensões'); ylabel('log10(Quantidade de pontos)');
title('Quantidade de pontos x dimensão (escala logaritmica)');
grid minor;
axis fill;
print -dpng -r400 figura13.png;