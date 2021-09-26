function [fmed, fdev, N] = intMCAnti(f, chi, boxlb, boxub, modo, stopcrit, rngconfig)
% Integra��o de Monte Carlo da fun��o f na regi�o R, utilizando amostragem
% antit�tica. 
%
% � f dx ~= <f> +- sqrt[(<f^2> - <f>^2/N)]
% R
% %%% RETORNOS %%%
% A fun��o retorna a estimativa da integral via m�dia das avalia��es, fmed,
% a estimativa de erro por meio do desvio padr�o, fdev, e a quantidade de
% itera��es, N. 
%
% %%% PAR�METROS %%%
% f � o integrando, deve ser um function_handle que aceita um array x
% x = [x1, ... xn]^T e retorna um escalar. 
%
% chi � a fun��o caracter�stica do conjunto R, deve ser dada na forma de
% um function_handle que aceita o array x e retorna um array de booleanos
% de tamanho dependendo da quantidade de restri��es.
% ex: chi = @(x) ((boxlb <= x).*(x <= boxub));
%
% boxlb e boxub s�o os limites inferior e superior da caixa n dimensional
% que cont�m R, s�o em formato de array com os limites em cada dimens�o
%
% rngconfig � a configura��o do gerador de n�meros aleat�rios. Se for um
% inteiro, � tomado como a semente para o gerador rng. Pode ser
% especificado tamb�m o uso de sequ�ncias quasi-aleat�rias, do tipo
% 'halton' ou 'sobol'. Nesse caso, � criado um stream quasi-aleatorio
% baseado nessa sequ�ncia, com quantidade de pontos igual ao n�mero de
% itera��es. Se n�o for especificado n�mero de itera��es, cria uma
% quantidade de pontos inversamente proporcional � toler�ncia. 
%
% modo � o tipo de crit�rio de para a ser usado, se � por n�mero de
% itera��es, use 'numIter', se � por toler�ncia relativa, use 'relTol'
%
% stopcrit � o crit�rio de parada. Se o modo for 'numIter', stopcrit deve
% ter o n�mero de itera��es que ser�o executadas. Se o modo for 'reltol',
% stopcrit deve ter a tolerancia relativa a ser atingida. 
%

if nargin < 7          % Se nenhuma semente for especificada, configura o
    rngconfig = 'shuffle'; % gerador de n�meros aleat�rios para o modo shuffle
end 

if nargin < 6
    numIter = 1e3; % Se n�o for especificada a condi��o de parada, usa-se
    relTol = 1e-2; % 1000 itera��es ou toler�ncia de 1% por default. 
else
    numIter = stopcrit;
    relTol = stopcrit;
end
    
if nargin < 5 % Se n�o for especificado o modo, assume-se 'numIter'. 
    modo = 'numIter';
end

d = length(boxlb);

if strcmp(modo, 'relTol')
    loopcond = @(N, relerr) ((N <= 5*d) || (relerr >= relTol));
else
    loopcond = @(N, relerr) (N <= numIter);
end

if strcmp(rngconfig, 'halton')
    qrsequence = @haltonset;
    scramblemethod = 'RR2';
elseif strcmp(rngconfig, 'sobol')
    qrsequence = @sobolset;
    scramblemethod = 'MatousekAffineOwen';
end

if isnumeric(rngconfig) %Se a configura��o for uma seed, 
    rng(rngconfig); %configura o gerador de n�meros aleat�rios
elseif strcmp(rngconfig, 'halton') || strcmp(rngconfig, 'sobol')
    %Se for especificada uma sequ�ncia quasi-aleatoria, configura o stream
    if strcmp(modo, 'numIter')
        p = scramble(qrsequence(d, 'Skip', 1e1, 'Leap', 1e16/numIter), scramblemethod);
    else
        p = scramble(qrsequence(d, 'Skip', 1e1, 'Leap', 1e16*relTol), scramblemethod);
    end
    q = qrandstream(p);
end

N = 0; %Inicializa vari�veis

fmed = 0;
fdev = 0;

acum_f = 0;
acum_fsqr = 0;

vol = prod( abs(boxub - boxlb) ); %Calcula o volume da caixa

while loopcond(N, fdev/abs(fmed))
    %Sorteia um ponto na caixa, e seu par antitetico
    if strcmp(rngconfig, 'halton') || strcmp(rngconfig, 'sobol')
        x = boxlb + (boxub-boxlb).* qrand(q)';
        x_anti = (boxlb + boxub) - x;
    else
        x = boxlb + (boxub-boxlb).* rand(size(boxub));
        x_anti = (boxlb + boxub) - x;
    end
    
    %Acumula a fun��o e o quadrado dela (se o ponto estiver no conjunto)
    acum_f = acum_f + f(x)*min(chi(x)) + f(x_anti)*min(chi(x_anti));
    acum_fsqr = acum_fsqr + (f(x)*min(chi(x))).^2 + (f(x_anti)*min(chi(x_anti))).^2;
    
    %Incrementa N (agora N significa o n�mero de itera��es, n�o de pontos)
    N = N + 1;
    
    %Calcula a m�dia e o desvio padr�o (note que a qtd de pontos ser� 2N)
    fmed = (vol)*acum_f/(2*N);
    fdev = (vol)*sqrt( (acum_fsqr/(2*N) - (acum_f/(2*N)).^2) / (2*N));
end

end