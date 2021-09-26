%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parte 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % A primeira an�lise que podemos fazer � comparar o m�todo de Monte Carlo
% % simples com sua variante quasi-aleat�ria. Para isso, vamos considerar uma
% % determinada integral e calcul�-la com diferentes quantidade de itera��es,
% % usando a gera��o de n�meros aleat�rios simples, a sequ�ncia de Halton e a
% % sequ�ncia de Sobol. 
% 
% % Vamos integrar a fun��o gaussiana em 3D, f(x,y,z) = exp(-(x^2+y^2+z^2)),
% % na regi�o c�bica de [-1, 1]^3. 
% f = @(x) exp(-sum(x.^2));
% boxlb = [-1;-1;-1]; boxub = -boxlb;
% chi = @(x) (boxlb <= x).*(x <= boxub);
% 
% % Vamos usar como valor de refer�ncia a resposta da rotina integral3,
% % nativa do MATLAB, que serve para calcular integrais triplas. 
% IntReferencia = integral3(@(x,y,z) exp(-(x.^2 + y.^2 + z.^2)), -1, 1, -1, 1, -1, 1);
% 
% % Vamos variar a quantidade de itera��es de 1e3 em 1e3 at� 1e5
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
% % Gr�fico da compara��o do valor da integral
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
% xlabel('Quantidade de itera��es'); ylabel('Valor da Integral');
% title('Compara��o entre MC simples e Quasi-MC');
% grid minor; axis fill;
% print -dpng -r400 figura7.png;
% 
% % Gr�fico dos erros absolutos
% figure; hold on;
% plot(QtdIter, abs(med_MC - IntReferencia), 'r-');
% plot(QtdIter, abs(med_QMCH - IntReferencia), 'g-');
% plot(QtdIter, abs(med_QMCS - IntReferencia), 'b-');
% legend('MC', 'QMCH', 'QMCS');
% xlabel('Quantidade de itera��es'); ylabel('Erro da integral');
% title('Compara��o entre MC simples e Quasi-MC');
% grid minor; axis fill;
% print -dpng -r400 figura8.png;
% 
% % Gr�fico dos desvios padr�o
% figure; hold on;
% plot(QtdIter, dev_MC, 'r-.');
% plot(QtdIter, dev_QMCH, 'g-.');
% plot(QtdIter, dev_QMCS, 'b-.');
% legend('MC', 'QMCH', 'QMCS');
% xlabel('Quantidade de itera��es'); ylabel('Desvio Padr�o');
% title('Compara��o entre MC simples e Quasi-MC');
% grid minor; axis fill;
% print -dpng -r400 figura9.png;
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parte 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% A segunda an�lise poss�vel � comparar o m�todo de Monte Carlo simples com
% suas variantes com amostragem antit�tica e amostragem estratificada. 
% 
% Vamos utilizar a fun��o de Rastrigin 3D, por ser um exemplo de fun��o com
% muita oscila��o, e cuja integral anal�tica pode ser facilmente calculada.
% dim = 3; A = 10;
% fRastrigin = @(x) A*dim + sum(x.^2) - A*sum(cos(2*pi.*x));
% 
% Vamos integr�-la no cubo [-5, 5]^3, ent�o seu valor exato ser�
% Iexata = (1e3)*A*dim + (1e2)*2*(5^3);
% 
% boxlb = [-5;-5;-5]; boxub = -boxlb; 
% chi = @(x) (boxlb <= x).*(x <= boxub); 
% 
% Vamos definir um requisito de toler�ncia
% relTol = 1e-2;
% 
% Vamos definir uma parti��o para a amostragem estratificada, de modo que
% favore�a a converg�ncia do m�todo. 
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
% Tabela com erros, desvios padr�o e n�mero de pontos. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parte 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% A terceira an�lise que podemos fazer � comparar o m�todo de Monte Carlo
% com o m�todo de integra��o iterada. Para tal, usaremos o mesmo problema
% de calcular o volume da bola unit�ria no Rn. 

% Medir tempo de execu��o para atingir 1e-3;
% Comparar os valores (m�dia com o anal�tico) e vari�ncia;
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
xlabel('N�mero de Dimens�es'); ylabel('log10(Tempo de execu��o (s))');
title('Custo do c�lculo do volume de B_n(1)');
grid minor;
axis fill;
print -dpng -r400 figura10.png;

% Valor da integral
figure; hold on;
plot(1:n, Ianalitica, 'b', 'LineWidth', 1.5); 
plot(1:n, fmed, 'r--', 'LineWidth', 1.5); 
legend('Valor Anal�tico', 'Valor Num�rico via MC');
xlabel('N�mero de Dimens�es'); ylabel('Valor da Integral');
title('Compara��o entre a integral de Monte Carlo e o valor exato');
grid minor;
axis fill;
print -dpng -r400 figura11.png;

% Erro absoluto
figure; hold on;
plot(1:n, abs(I - Ianalitica), 'b');
plot(1:n, abs(fmed - Ianalitica), 'r');
plot(1:n, fdev, 'y-.');
legend('Erro intmult', 'Erro MC', 'Desvio padr�o MC');
xlabel('N�mero de Dimens�es'); 
ylabel('Erro absoluto |I_numerica - I_analitica|');
title('Erro absoluto da integra��o num�rica');
grid minor;
axis fill;
print -dpng -r400 figura12.png;

% Qtd de pontos
figure; hold on;
plot(1:n, log10(qtdpontos), 'b-o');
plot(1:n, log10(N), 'r-o');
xlabel('N�mero de Dimens�es'); ylabel('log10(Quantidade de pontos)');
title('Quantidade de pontos x dimens�o (escala logaritmica)');
grid minor;
axis fill;
print -dpng -r400 figura13.png;