function [I, pontos] = intmult(f, lim, eps, dim)
% A rotina intmult calcula a integral multipla de dimensão dim, da função
% f, a qual deve estar escrita de forma a receber um array como argumento.
%
%     b1     b2(x1)      bn(x1,...,xn-1)
% I = § dx1    §  dx2  ...     §  dxn   f(x1,...,xn)
%     a1     a2(x1)      an(x1,...,xn-1)
%
% Por exemplo, f deve ser um function_handle no formato:
% f = @(x) ( x(1)^2 + 3*x(2) - x*x');
%
% Note que a implementação supõe um argumento em formato de matriz linha,
% x = [x1, x2, ..., xn].
% Isso é feito para que se possa implementar um método para uma quantidade
% arbitrária de dimensões. A limitação consequente é que a função não pode
% produzir saídas vetoriais. 
%
% Os limites de integração são definidos no argumento lim, que deve conter
% function_handles para os limites de integração das integrais interiores. 
% Dessa forma, devemos utilizar um cell array com n linhas e 2 colunas. 
% A primeira coluna é para os limites inferiores, e a segunda para limites
% superiores. Cada linha é referente aos limites de integração de uma das
% n integrais iteradas. 
% Novamente, para termos escalabilidade nas dimensões, devemos implementar
% os limites de integração como function handles que recebem um array, a 
% menos da primeira linha, que deve conter apenas dois números. 
% Ex:
% lim{1,1} = a; lim{1,2} = b
% lim{2,1} = @(x) -sqrt(1 - x(1)^2); lim{2,1} = @(x)sqrt(1 - x(1)^2); 
% lim{3,1} = @(x) -sqrt(1 - x(1)^2+x(2)^2); lim{3,2} = @(x) -sqrt(1 - x(1)^2+x(2)^2);
% ...
%
% O argumento eps é simplesmente um array de dim entradas contendo as 
% tolerâncias a serem passadas para o método de integração por quadratura
% adaptativa, usado para calcular cada uma das integrais iteradas. 
%
% O argumento dim é simplesmente a dimensionalidade da integral, i.e., se
% a integral é dupla, dim = 2, se é tripla, dim = 3, etc.
%

%Definimos essa primeira condição de parada para evitar loops infinitos
%quando o intervalo de integração na primeira dimensão é um ponto. 
L = lim{1,2} - lim{1,1};
I = 0;
pontos = [];
if L ~= 0    
    %Nossa segunda condição de parada é quando o problema se reduz a uma
    %dimensão, onde invocamos uma simples quadratura adaptativa. 
if dim == 1
    [I, pontos] = intQA(f, lim{1,1}, lim{1,2}, eps);
else
    %Como na quadratura adaptativa 1D, calculamos a função nos extremos e 
    %no ponto médio do intervalo. 
    pext = [lim{1,1}, (lim{1,1}+lim{1,2})/2, lim{1,2}]; %Pontos da integral externa
    Iext = zeros(3,1); %Valores da integral externa
    
    %O cell array <limites internos> serve para manter a compatibilidade
    %dos limites de integração nas integrais mais internas.
    limin = cell(dim-1, 2);
    
    for i = 1:3
        limin{1,1} = lim{2,1}( pext(i) ); %Devemos transformar esse func_hand
        limin{1,2} = lim{2,2}( pext(i) ); %em simplesmente números
        for j = 2:dim-1
            limin{j,1} = @(xin) lim{j+1,1}([pext(i), xin]); %E devemos fixar o primeiro
            limin{j,2} = @(xin) lim{j+1,2}([pext(i), xin]); %argumento desses func_hand
        end
        %Note que para calcular essa integral (amostrar o integrando da
        %integral mais externa) devemos fixar o primeiro argumento da
        %função como pext(i), e realizar uma integral (dim-1)D. 
        [Iext(i), pint] = intmult(@(xin) f([pext(i), xin]), limin, eps(2:end), dim-1);
        pontos = [pontos; [pext(i)*ones(size(pint,1),1) , pint]];
    end
    
    %Em seguida, aplicamos a bissecção da quadratura adaptativa (BQA)
    [I, pontos] = multBQA(f, lim, L, eps, Iext, pontos, dim);
end

end

end

function [I, pontos] = multBQA(f, lim, L, eps, Iext, pts, dim)
%Bissecção da Quadratura Adaptativa (Múltipla)
%Essa função serve para refinar o valor da integral no intervalo dado, 
%até atingir a precisão eps. Note que temos o function-handle da f
%original, além de valores calculados da integral mais externa Iext. 
%Os demais parâmetros são necessários para que possamos calcular mais
%valores da integral externa para decidir se precisamos refinar mais o
%intervalo ou não. 

pontos = [];

%Define pontos inicial, médio e final
pi = lim{1,1}; pm = (lim{1,1}+lim{1,2})/2; pf = lim{1,2};
pref = [pi; (pi+pm)/2; pm; (pm+pf)/2; pf]; %Pontos do refinamento

%Novamente temos amostrar valores da integral externa para o refinamento
Iextref = [Iext(1); 0; Iext(2); 0; Iext(3)];

limin = cell(dim-1, 1);
for i = [2,4]
    limin{1,1} = lim{2,1}( pref(i) ); 
    limin{1,2} = lim{2,2}( pref(i) );
    for j = 2:dim-1
        limin{j,1} = @(xin) lim{j+1,1}([pref(i), xin]); 
        limin{j,2} = @(xin) lim{j+1,2}([pref(i), xin]);
    end
    [Iextref(i), pint] = intmult(@(xin) f([pref(i), xin]), limin, eps(2:end), dim-1);
    pontos = [pontos; [pref(i)*ones(size(pint,1), 1), pint]];
end

%Calcula a quadratura atual e a refinada
Q = IntegracaoSimpson((pf-pi)/2, Iext);
Qref = IntegracaoSimpson((pf-pi)/4, Iextref);

%Critério de parada da quadratura adaptativa normal. Note que aqui usamos
%o valor de eps(1), que é a tolerância de erro na integral mais externa.
if abs(Q-Qref) < eps(1)*15*(pf-pi)/L
    I = Qref;
    pontos = [pts; pontos];
else
    %Se não for atendido, quebramos o intervalo em dois e refinamos a 
    %quadratura. 
    lim{1,1} = pi; lim{1,2} = pm;
    [I1, pontos1] = multBQA(f, lim, L, eps, Iextref(1:3), [], dim);
    
    lim{1,1} = pm; lim{1,2} = pf;
    [I2, pontos2] = multBQA(f, lim, L, eps, Iextref(3:5), [], dim);
    
    %No final disso, somamos os valores já refinados. 
    I = I1 + I2;
    pontos = [pontos; pontos1; pontos2];
end

end