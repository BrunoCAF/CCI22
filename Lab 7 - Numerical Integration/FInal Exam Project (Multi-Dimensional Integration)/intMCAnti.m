function [fmed, fdev, N] = intMCAnti(f, chi, boxlb, boxub, modo, stopcrit, rngconfig)
% Integração de Monte Carlo da função f na região R, utilizando amostragem
% antitética. 
%
% § f dx ~= <f> +- sqrt[(<f^2> - <f>^2/N)]
% R
% %%% RETORNOS %%%
% A função retorna a estimativa da integral via média das avaliações, fmed,
% a estimativa de erro por meio do desvio padrão, fdev, e a quantidade de
% iterações, N. 
%
% %%% PARÂMETROS %%%
% f é o integrando, deve ser um function_handle que aceita um array x
% x = [x1, ... xn]^T e retorna um escalar. 
%
% chi é a função característica do conjunto R, deve ser dada na forma de
% um function_handle que aceita o array x e retorna um array de booleanos
% de tamanho dependendo da quantidade de restrições.
% ex: chi = @(x) ((boxlb <= x).*(x <= boxub));
%
% boxlb e boxub são os limites inferior e superior da caixa n dimensional
% que contém R, são em formato de array com os limites em cada dimensão
%
% rngconfig é a configuração do gerador de números aleatórios. Se for um
% inteiro, é tomado como a semente para o gerador rng. Pode ser
% especificado também o uso de sequências quasi-aleatórias, do tipo
% 'halton' ou 'sobol'. Nesse caso, é criado um stream quasi-aleatorio
% baseado nessa sequência, com quantidade de pontos igual ao número de
% iterações. Se não for especificado número de iterações, cria uma
% quantidade de pontos inversamente proporcional à tolerância. 
%
% modo é o tipo de critério de para a ser usado, se é por número de
% iterações, use 'numIter', se é por tolerância relativa, use 'relTol'
%
% stopcrit é o critério de parada. Se o modo for 'numIter', stopcrit deve
% ter o número de iterações que serão executadas. Se o modo for 'reltol',
% stopcrit deve ter a tolerancia relativa a ser atingida. 
%

if nargin < 7          % Se nenhuma semente for especificada, configura o
    rngconfig = 'shuffle'; % gerador de números aleatórios para o modo shuffle
end 

if nargin < 6
    numIter = 1e3; % Se não for especificada a condição de parada, usa-se
    relTol = 1e-2; % 1000 iterações ou tolerância de 1% por default. 
else
    numIter = stopcrit;
    relTol = stopcrit;
end
    
if nargin < 5 % Se não for especificado o modo, assume-se 'numIter'. 
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

if isnumeric(rngconfig) %Se a configuração for uma seed, 
    rng(rngconfig); %configura o gerador de números aleatórios
elseif strcmp(rngconfig, 'halton') || strcmp(rngconfig, 'sobol')
    %Se for especificada uma sequência quasi-aleatoria, configura o stream
    if strcmp(modo, 'numIter')
        p = scramble(qrsequence(d, 'Skip', 1e1, 'Leap', 1e16/numIter), scramblemethod);
    else
        p = scramble(qrsequence(d, 'Skip', 1e1, 'Leap', 1e16*relTol), scramblemethod);
    end
    q = qrandstream(p);
end

N = 0; %Inicializa variáveis

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
    
    %Acumula a função e o quadrado dela (se o ponto estiver no conjunto)
    acum_f = acum_f + f(x)*min(chi(x)) + f(x_anti)*min(chi(x_anti));
    acum_fsqr = acum_fsqr + (f(x)*min(chi(x))).^2 + (f(x_anti)*min(chi(x_anti))).^2;
    
    %Incrementa N (agora N significa o número de iterações, não de pontos)
    N = N + 1;
    
    %Calcula a média e o desvio padrão (note que a qtd de pontos será 2N)
    fmed = (vol)*acum_f/(2*N);
    fdev = (vol)*sqrt( (acum_fsqr/(2*N) - (acum_f/(2*N)).^2) / (2*N));
end

end