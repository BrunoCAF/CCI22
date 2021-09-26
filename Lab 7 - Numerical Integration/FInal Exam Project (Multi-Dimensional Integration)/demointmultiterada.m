%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parte 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % 1o Exemplo: Calculando a massa de um paraboloide elíptico com densidade
% den = @(x) x(1)*x(3)^4; %Densidade depende da 1a e 3a coordenadas, x e z
% 
% % O paraboloide tem equação: x = (y/2)^2 + z^2; 0 <= x <= 9;
% % Vamos integrar fazendo 
% % 9     2sqrt[x]     sqrt[x-(y/2)^2]
% % § dx     §   dy          §        x*|z|   dz
% % 0    -2sqrt[x]    -sqrt[x-(y/2)^2]
% 
% % Definindo os limites de integração:
% limits{1,1} = 0; limits{1,2} = 9; %Aqui os limites são só números
% limits{2,1} = @(x) -2*sqrt(x); limits{2,2} = @(x) 2*sqrt(x); %Aqui são funções
% limits{3,1} = @(x_y) -sqrt(x_y(1) - (x_y(2)/2).^2); %E aqui são funções que
% limits{3,2} = @(x_y) +sqrt(x_y(1) - (x_y(2)/2).^2); %recebem 2 argumentos, x e y
% 
% % O valor exato da integral (obtido analiticamente) é de 59049*pi/20
% Iexato = 59049*pi/20;
% 
% 
% % Vamos definir a precisão em cada dimensão
% epsilon = [1e-3; 1e-4; 1e-6];
% % E por fim, vamos integrar:
% [I, pontos] = intmult(den, limits, epsilon, 3); % 3 é a dimensão da integral
% % Calculando o erro absoluto e a quantidade de pontos
% erro = abs(I-Iexato);
% qtdpontos = size(pontos, 1);
% 
% 
% % Mas e se tivéssemos definido as precisões como
% epsilon = [1e-3; 1e-3; 1e-6]; %Apenas mudamos a precisão em y
% [I, pontos] = intmult(den, limits, epsilon, 3);
% erro_p = abs(I-Iexato); 
% qtdpontos_p = size(pontos,1);
% 
% % Agora com uma precisão ainda pior
% epsilon = [1e-3; 1e-3; 1e-3]; % Mudamos a precisão em z
% [I, pontos] = intmult(den, limits, epsilon, 3);
% erro_pp = abs(I-Iexato); 
% qtdpontos_pp = size(pontos,1);
% 
% %[erro; erro_p; erro_pp]
% %[qtdpontos; qtdpontos_p; qtdpontos_pp]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parte 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % 2o Exemplo: Monitorando os pontos da quadratura adaptativa (em 2D) 
% % Vamos tomar uma função com um comportamento bastante oscilatório numa
% % determinada região, mas que seja relativamente suave em outra, e integrar
% % essa função numa região que contemple os dois comportamentos. 
% 
% % Uma possibilidade é algo com sen e cos, amortecido por uma gaussiana
% f = @(x) sin(10*x(1))*cos(6*x(2))*exp(-(4*(x(1)-1)^2 + 2*(x(2)-2)^2));
% % O gráfico de f nos permite notar que f oscila muito na região
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
% title('Gráfico da função f');
% grid on; grid minor;
% axis fill;
% print -dpng -r400 figura1.png;
% 
% % Vamos tomar a região [0,4]x[0,4] como área de integração. 
% limits{1,1} =      0; limits{1,2} =      4;
% limits{2,1} = @(x) 0; limits{2,2} = @(x) 4;
% 
% % Como o valor de f é muito pequeno (não passa de 1 em todo o plano) e tem
% % simetrias, a integral resultará num número de magnitude muito baixa.
% % Contudo, para esse exemplo queremos apenas ilustrar a distribuição dos
% % pontos, portanto não vamos usar uma precisão absoluta muito grande. 
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
% intmult com a quantidade de dimensões. Tomaremos uma função simples. 

% Para isso, vamos considerar o problema de calcular o volume da bola
% unitária n-dimensional.
%       §  dx
% {||x|| <= 1}
%
f = @(x) 1;

% No caso, a integral pode ser resolvida analiticamente. É sabido que o
% volume da bola em Rn sera dado por pi^(n/2)/(gamma(n/2)*(n/2)). 
VolBola = @(n) ( pi.^(n./2) ) / ( gamma(n./2) .* (n./2) ); 

% Vamos calcular para no máximo 5 dimensões. Acima desse valor, o tempo de
% execução se torna impeditivo. 
n = 5;

% Vamos definir os limites de integração. Como o integrando é uma bola, as
% expressões para os limites serão parecidas;
clear limits;
limits{1,1} = -1; limits{1,2} = 1;
for i = 2:n
    limits{i,1} = @(x) (- sqrt(1 - norm(x)^2)) ;
    limits{i,2} = @(x) (- limits{i,1}(x));
end

% Vamos definir precisões que nos permitam um resultado acurado:
epsilon = zeros(n,1);
for i = 1:n
    epsilon(i) = 1e-2 / 10^i;
end

% Agora vamos realizar a integração para os casos de n = 1, ..., 6.
I = zeros(n,1); erro = zeros(n,1); Ianalitica = zeros(n,1);
qtdpontos = zeros(n,1); tempos = zeros(n,1);
for dim = 1:n
    % Realiza a integração e mede o tempo de max integrações
    max = 100;
    if dim > 3
        max = 1;
    end
    tic;
    for j = 1:max
        [I(dim), pontos] = intmult(f, limits, epsilon, dim);
    end
    tempos(dim) = toc/max;
    
    % Mede o erro absoluto da integração e a quantidade de pontos usados:
    Ianalitica(dim) = VolBola(dim);
    erro(dim) = abs(I(dim) - VolBola(dim));
    qtdpontos(dim) = size(pontos, 1);
end

% Tempos
figure; hold on;
plot(1:n, log10(tempos), '-rd');
xlabel('Número de Dimensões'); ylabel('log10(Tempo de execução (s))');
title('Custo computacional da integração do volume da bola unitária do R^n');
grid minor;
axis fill;
print -dpng -r400 figura3.png;

% Valor da integral
figure; hold on;
plot(1:n, Ianalitica, 'b', 'LineWidth', 1.5); 
plot(1:n, I, 'r--', 'LineWidth', 1.5); 
legend('Valor Analítico', 'Valor Numérico');
xlabel('Número de Dimensões'); ylabel('Valor da Integral');
title('Comparação entre a integral numérica e analítica');
grid minor;
axis fill;
print -dpng -r400 figura4.png;

% Erro absoluto
figure; hold on;
plot(1:n, abs(I - Ianalitica));
xlabel('Número de Dimensões'); ylabel('Erro absoluto |I_numerica - I_analitica|');
title('Erro absoluto da integração numérica');
grid minor;
axis fill;
print -dpng -r400 figura5.png;

% Qtd de pontos
figure; hold on;
plot(1:n, log10(qtdpontos), '-o');
xlabel('Número de Dimensões'); ylabel('log10(Quantidade de pontos)');
title('Quantidade de pontos x dimensão (escala logaritmica)');
grid minor;
axis fill;
print -dpng -r400 figura6.png;

savefile = 'infobola.mat';
save(savefile, 'tempos', 'I', 'qtdpontos');
