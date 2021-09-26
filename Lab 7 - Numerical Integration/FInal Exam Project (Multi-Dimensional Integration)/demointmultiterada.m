%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parte 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % 1o Exemplo: Calculando a massa de um paraboloide el�ptico com densidade
% den = @(x) x(1)*x(3)^4; %Densidade depende da 1a e 3a coordenadas, x e z
% 
% % O paraboloide tem equa��o: x = (y/2)^2 + z^2; 0 <= x <= 9;
% % Vamos integrar fazendo 
% % 9     2sqrt[x]     sqrt[x-(y/2)^2]
% % � dx     �   dy          �        x*|z|   dz
% % 0    -2sqrt[x]    -sqrt[x-(y/2)^2]
% 
% % Definindo os limites de integra��o:
% limits{1,1} = 0; limits{1,2} = 9; %Aqui os limites s�o s� n�meros
% limits{2,1} = @(x) -2*sqrt(x); limits{2,2} = @(x) 2*sqrt(x); %Aqui s�o fun��es
% limits{3,1} = @(x_y) -sqrt(x_y(1) - (x_y(2)/2).^2); %E aqui s�o fun��es que
% limits{3,2} = @(x_y) +sqrt(x_y(1) - (x_y(2)/2).^2); %recebem 2 argumentos, x e y
% 
% % O valor exato da integral (obtido analiticamente) � de 59049*pi/20
% Iexato = 59049*pi/20;
% 
% 
% % Vamos definir a precis�o em cada dimens�o
% epsilon = [1e-3; 1e-4; 1e-6];
% % E por fim, vamos integrar:
% [I, pontos] = intmult(den, limits, epsilon, 3); % 3 � a dimens�o da integral
% % Calculando o erro absoluto e a quantidade de pontos
% erro = abs(I-Iexato);
% qtdpontos = size(pontos, 1);
% 
% 
% % Mas e se tiv�ssemos definido as precis�es como
% epsilon = [1e-3; 1e-3; 1e-6]; %Apenas mudamos a precis�o em y
% [I, pontos] = intmult(den, limits, epsilon, 3);
% erro_p = abs(I-Iexato); 
% qtdpontos_p = size(pontos,1);
% 
% % Agora com uma precis�o ainda pior
% epsilon = [1e-3; 1e-3; 1e-3]; % Mudamos a precis�o em z
% [I, pontos] = intmult(den, limits, epsilon, 3);
% erro_pp = abs(I-Iexato); 
% qtdpontos_pp = size(pontos,1);
% 
% %[erro; erro_p; erro_pp]
% %[qtdpontos; qtdpontos_p; qtdpontos_pp]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parte 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % 2o Exemplo: Monitorando os pontos da quadratura adaptativa (em 2D) 
% % Vamos tomar uma fun��o com um comportamento bastante oscilat�rio numa
% % determinada regi�o, mas que seja relativamente suave em outra, e integrar
% % essa fun��o numa regi�o que contemple os dois comportamentos. 
% 
% % Uma possibilidade � algo com sen e cos, amortecido por uma gaussiana
% f = @(x) sin(10*x(1))*cos(6*x(2))*exp(-(4*(x(1)-1)^2 + 2*(x(2)-2)^2));
% % O gr�fico de f nos permite notar que f oscila muito na regi�o
% % [0,2]x[0,4], e se suaviza em [2,4]x[0,4]. 
% 
% [X, Y] = meshgrid(0:0.02:4, 0:0.02:4); m = size(X, 1) * size(Y, 2);
% x = reshape(X, m, 1); y = reshape(Y, m, 1);
% 
% fplot = @(x,y) sin(10.*x).*cos(6.*y).*exp(-(4.*(x-1).^2 + 2.*(y-2).^2));
% Z = fplot(0:0.02:4, (0:0.02:4)');
% 
% figure;
% surf(0:0.02:4, 0:0.02:4, Z);
% hold on;
% xlabel('x'); ylabel('y'); zlabel('f(x,y) = sin(10x)*cos(6y)*exp(- 4(x-1)^2 - 2(y-2)^2))');
% title('Gr�fico da fun��o f');
% grid on; grid minor;
% axis fill;
% print -dpng -r400 figura1.png;
% 
% % Vamos tomar a regi�o [0,4]x[0,4] como �rea de integra��o. 
% limits{1,1} =      0; limits{1,2} =      4;
% limits{2,1} = @(x) 0; limits{2,2} = @(x) 4;
% 
% % Como o valor de f � muito pequeno (n�o passa de 1 em todo o plano) e tem
% % simetrias, a integral resultar� num n�mero de magnitude muito baixa.
% % Contudo, para esse exemplo queremos apenas ilustrar a distribui��o dos
% % pontos, portanto n�o vamos usar uma precis�o absoluta muito grande. 
% epsilon = [1e-4; 1e-6];
% 
% [~, pontos] = intmult(f, limits, epsilon, 2);
% 
% % Vamos plotar agora os pontos utilizados na quadratura
% 
% figure;
% hold on;
% plot(pontos(:,1), pontos(:,2), 'r*');
% xlabel('x'); ylabel('y');
% title('Pontos utilizados na quadratura - Total de 4222 pontos');
% grid minor;
% axis fill;
% print -dpng -r400 figura2.png;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parte 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 3o Exemplo: Vamos estudar o crescimento do custo computacional da rotina
% intmult com a quantidade de dimens�es. Tomaremos uma fun��o simples. 

% Para isso, vamos considerar o problema de calcular o volume da bola
% unit�ria n-dimensional.
%       �  dx
% {||x|| <= 1}
%
f = @(x) 1;

% No caso, a integral pode ser resolvida analiticamente. � sabido que o
% volume da bola em Rn sera dado por pi^(n/2)/(gamma(n/2)*(n/2)). 
VolBola = @(n) ( pi.^(n./2) ) / ( gamma(n./2) .* (n./2) ); 

% Vamos calcular para no m�ximo 5 dimens�es. Acima desse valor, o tempo de
% execu��o se torna impeditivo. 
n = 5;

% Vamos definir os limites de integra��o. Como o integrando � uma bola, as
% express�es para os limites ser�o parecidas;
clear limits;
limits{1,1} = -1; limits{1,2} = 1;
for i = 2:n
    limits{i,1} = @(x) (- sqrt(1 - norm(x)^2)) ;
    limits{i,2} = @(x) (- limits{i,1}(x));
end

% Vamos definir precis�es que nos permitam um resultado acurado:
epsilon = zeros(n,1);
for i = 1:n
    epsilon(i) = 1e-2 / 10^i;
end

% Agora vamos realizar a integra��o para os casos de n = 1, ..., 6.
I = zeros(n,1); erro = zeros(n,1); Ianalitica = zeros(n,1);
qtdpontos = zeros(n,1); tempos = zeros(n,1);
for dim = 1:n
    % Realiza a integra��o e mede o tempo de max integra��es
    max = 100;
    if dim > 3
        max = 1;
    end
    tic;
    for j = 1:max
        [I(dim), pontos] = intmult(f, limits, epsilon, dim);
    end
    tempos(dim) = toc/max;
    
    % Mede o erro absoluto da integra��o e a quantidade de pontos usados:
    Ianalitica(dim) = VolBola(dim);
    erro(dim) = abs(I(dim) - VolBola(dim));
    qtdpontos(dim) = size(pontos, 1);
end

% Tempos
figure; hold on;
plot(1:n, log10(tempos), '-rd');
xlabel('N�mero de Dimens�es'); ylabel('log10(Tempo de execu��o (s))');
title('Custo computacional da integra��o do volume da bola unit�ria do R^n');
grid minor;
axis fill;
print -dpng -r400 figura3.png;

% Valor da integral
figure; hold on;
plot(1:n, Ianalitica, 'b', 'LineWidth', 1.5); 
plot(1:n, I, 'r--', 'LineWidth', 1.5); 
legend('Valor Anal�tico', 'Valor Num�rico');
xlabel('N�mero de Dimens�es'); ylabel('Valor da Integral');
title('Compara��o entre a integral num�rica e anal�tica');
grid minor;
axis fill;
print -dpng -r400 figura4.png;

% Erro absoluto
figure; hold on;
plot(1:n, abs(I - Ianalitica));
xlabel('N�mero de Dimens�es'); ylabel('Erro absoluto |I_numerica - I_analitica|');
title('Erro absoluto da integra��o num�rica');
grid minor;
axis fill;
print -dpng -r400 figura5.png;

% Qtd de pontos
figure; hold on;
plot(1:n, log10(qtdpontos), '-o');
xlabel('N�mero de Dimens�es'); ylabel('log10(Quantidade de pontos)');
title('Quantidade de pontos x dimens�o (escala logaritmica)');
grid minor;
axis fill;
print -dpng -r400 figura6.png;

savefile = 'infobola.mat';
save(savefile, 'tempos', 'I', 'qtdpontos');
