function [fmed, fdev, N] = intMCEstr(f, chi, boxlb, boxub, P, relTol, rngconfig)
% Integração de Monte Carlo da função f na região R, utilizando amostragem
% estratificada
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
% P é o vetor que contém a quantidade de partições em cada dimensão. Deve
% estar em formato de matriz coluna. Ex: P = [2; 3; 2], significa uma
% partição em 2x3x2 subregiões. 
%
% relTol é a tolerância relativa a ser atingida. Para essa implementação,
% não há a opção de escolher o número de iterações, por razões práticas do
% algoritmo. 
%
% rngconfig é a configuração do gerador de números aleatórios. Se for um
% inteiro, é tomado como a semente para o gerador rng. Pode ser
% especificado também o uso de sequências quasi-aleatórias, do tipo
% 'halton' ou 'sobol'. Nesse caso, é criado um stream quasi-aleatorio
% baseado nessa sequência, com quantidade de pontos igual ao número de
% iterações. Se não for especificado número de iterações, cria uma
% quantidade de pontos inversamente proporcional à tolerância. 
%

if nargin < 7          % Se nenhuma semente for especificada, configura o
    rngconfig = 'shuffle'; % gerador de números aleatórios para o modo shuffle
end 
if nargin < 6       % Se nenhuma precisão for especificada,
    relTol = 1e-2;  % usa 1% por default. 
end

N = 0; %Inicializa variáveis
fmed = 0;
fdev = 0;

%Definindo número de partições e vetor auxiliar
nP = prod(P);
Q = prod(triu(P*ones(size(P'))) + tril(ones(length(P))) - eye(length(P)));
Q = [1;Q(1:end-1)'];

for i = 1:nP
    %Definindo vetor que indexa as partições
    v = mod(floor((i-1)./Q), P);
    %Definindo vetor diagonal de cada partição
    dpart = (boxub-boxlb)./P;
    
    %Os limites da subcaixa serão
    lb = boxlb + v.*dpart; ub = lb + dpart;
    
    %Integra na subcaixa
    [medsub, devsub, Nsub] = intmontecarlo(f, chi, lb, ub, 'relTol', relTol/sqrt(nP), rngconfig);
    
    %Acumula os resultados
    fmed = fmed + medsub;
    fdev = sqrt(fdev^2 + devsub^2);
    N = N + Nsub;
end

end