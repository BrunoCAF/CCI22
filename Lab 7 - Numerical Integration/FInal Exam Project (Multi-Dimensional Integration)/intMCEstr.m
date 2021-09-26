function [fmed, fdev, N] = intMCEstr(f, chi, boxlb, boxub, P, relTol, rngconfig)
% Integra��o de Monte Carlo da fun��o f na regi�o R, utilizando amostragem
% estratificada
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
% P � o vetor que cont�m a quantidade de parti��es em cada dimens�o. Deve
% estar em formato de matriz coluna. Ex: P = [2; 3; 2], significa uma
% parti��o em 2x3x2 subregi�es. 
%
% relTol � a toler�ncia relativa a ser atingida. Para essa implementa��o,
% n�o h� a op��o de escolher o n�mero de itera��es, por raz�es pr�ticas do
% algoritmo. 
%
% rngconfig � a configura��o do gerador de n�meros aleat�rios. Se for um
% inteiro, � tomado como a semente para o gerador rng. Pode ser
% especificado tamb�m o uso de sequ�ncias quasi-aleat�rias, do tipo
% 'halton' ou 'sobol'. Nesse caso, � criado um stream quasi-aleatorio
% baseado nessa sequ�ncia, com quantidade de pontos igual ao n�mero de
% itera��es. Se n�o for especificado n�mero de itera��es, cria uma
% quantidade de pontos inversamente proporcional � toler�ncia. 
%

if nargin < 7          % Se nenhuma semente for especificada, configura o
    rngconfig = 'shuffle'; % gerador de n�meros aleat�rios para o modo shuffle
end 
if nargin < 6       % Se nenhuma precis�o for especificada,
    relTol = 1e-2;  % usa 1% por default. 
end

N = 0; %Inicializa vari�veis
fmed = 0;
fdev = 0;

%Definindo n�mero de parti��es e vetor auxiliar
nP = prod(P);
Q = prod(triu(P*ones(size(P'))) + tril(ones(length(P))) - eye(length(P)));
Q = [1;Q(1:end-1)'];

for i = 1:nP
    %Definindo vetor que indexa as parti��es
    v = mod(floor((i-1)./Q), P);
    %Definindo vetor diagonal de cada parti��o
    dpart = (boxub-boxlb)./P;
    
    %Os limites da subcaixa ser�o
    lb = boxlb + v.*dpart; ub = lb + dpart;
    
    %Integra na subcaixa
    [medsub, devsub, Nsub] = intmontecarlo(f, chi, lb, ub, 'relTol', relTol/sqrt(nP), rngconfig);
    
    %Acumula os resultados
    fmed = fmed + medsub;
    fdev = sqrt(fdev^2 + devsub^2);
    N = N + Nsub;
end

end