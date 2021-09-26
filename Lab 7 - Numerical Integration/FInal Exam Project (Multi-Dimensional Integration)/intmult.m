function [I, pontos] = intmult(f, lim, eps, dim)
% A rotina intmult calcula a integral multipla de dimens�o dim, da fun��o
% f, a qual deve estar escrita de forma a receber um array como argumento.
%
%     b1     b2(x1)      bn(x1,...,xn-1)
% I = � dx1    �  dx2  ...     �  dxn   f(x1,...,xn)
%     a1     a2(x1)      an(x1,...,xn-1)
%
% Por exemplo, f deve ser um function_handle no formato:
% f = @(x) ( x(1)^2 + 3*x(2) - x*x');
%
% Note que a implementa��o sup�e um argumento em formato de matriz linha,
% x = [x1, x2, ..., xn].
% Isso � feito para que se possa implementar um m�todo para uma quantidade
% arbitr�ria de dimens�es. A limita��o consequente � que a fun��o n�o pode
% produzir sa�das vetoriais. 
%
% Os limites de integra��o s�o definidos no argumento lim, que deve conter
% function_handles para os limites de integra��o das integrais interiores. 
% Dessa forma, devemos utilizar um cell array com n linhas e 2 colunas. 
% A primeira coluna � para os limites inferiores, e a segunda para limites
% superiores. Cada linha � referente aos limites de integra��o de uma das
% n integrais iteradas. 
% Novamente, para termos escalabilidade nas dimens�es, devemos implementar
% os limites de integra��o como function handles que recebem um array, a 
% menos da primeira linha, que deve conter apenas dois n�meros. 
% Ex:
% lim{1,1} = a; lim{1,2} = b
% lim{2,1} = @(x) -sqrt(1 - x(1)^2); lim{2,1} = @(x)sqrt(1 - x(1)^2); 
% lim{3,1} = @(x) -sqrt(1 - x(1)^2+x(2)^2); lim{3,2} = @(x) -sqrt(1 - x(1)^2+x(2)^2);
% ...
%
% O argumento eps � simplesmente um array de dim entradas contendo as 
% toler�ncias a serem passadas para o m�todo de integra��o por quadratura
% adaptativa, usado para calcular cada uma das integrais iteradas. 
%
% O argumento dim � simplesmente a dimensionalidade da integral, i.e., se
% a integral � dupla, dim = 2, se � tripla, dim = 3, etc.
%

%Definimos essa primeira condi��o de parada para evitar loops infinitos
%quando o intervalo de integra��o na primeira dimens�o � um ponto. 
L = lim{1,2} - lim{1,1};
I = 0;
pontos = [];
if L ~= 0    
    %Nossa segunda condi��o de parada � quando o problema se reduz a uma
    %dimens�o, onde invocamos uma simples quadratura adaptativa. 
if dim == 1
    [I, pontos] = intQA(f, lim{1,1}, lim{1,2}, eps);
else
    %Como na quadratura adaptativa 1D, calculamos a fun��o nos extremos e 
    %no ponto m�dio do intervalo. 
    pext = [lim{1,1}, (lim{1,1}+lim{1,2})/2, lim{1,2}]; %Pontos da integral externa
    Iext = zeros(3,1); %Valores da integral externa
    
    %O cell array <limites internos> serve para manter a compatibilidade
    %dos limites de integra��o nas integrais mais internas.
    limin = cell(dim-1, 2);
    
    for i = 1:3
        limin{1,1} = lim{2,1}( pext(i) ); %Devemos transformar esse func_hand
        limin{1,2} = lim{2,2}( pext(i) ); %em simplesmente n�meros
        for j = 2:dim-1
            limin{j,1} = @(xin) lim{j+1,1}([pext(i), xin]); %E devemos fixar o primeiro
            limin{j,2} = @(xin) lim{j+1,2}([pext(i), xin]); %argumento desses func_hand
        end
        %Note que para calcular essa integral (amostrar o integrando da
        %integral mais externa) devemos fixar o primeiro argumento da
        %fun��o como pext(i), e realizar uma integral (dim-1)D. 
        [Iext(i), pint] = intmult(@(xin) f([pext(i), xin]), limin, eps(2:end), dim-1);
        pontos = [pontos; [pext(i)*ones(size(pint,1),1) , pint]];
    end
    
    %Em seguida, aplicamos a bissec��o da quadratura adaptativa (BQA)
    [I, pontos] = multBQA(f, lim, L, eps, Iext, pontos, dim);
end

end

end

function [I, pontos] = multBQA(f, lim, L, eps, Iext, pts, dim)
%Bissec��o da Quadratura Adaptativa (M�ltipla)
%Essa fun��o serve para refinar o valor da integral no intervalo dado, 
%at� atingir a precis�o eps. Note que temos o function-handle da f
%original, al�m de valores calculados da integral mais externa Iext. 
%Os demais par�metros s�o necess�rios para que possamos calcular mais
%valores da integral externa para decidir se precisamos refinar mais o
%intervalo ou n�o. 

pontos = [];

%Define pontos inicial, m�dio e final
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

%Crit�rio de parada da quadratura adaptativa normal. Note que aqui usamos
%o valor de eps(1), que � a toler�ncia de erro na integral mais externa.
if abs(Q-Qref) < eps(1)*15*(pf-pi)/L
    I = Qref;
    pontos = [pts; pontos];
else
    %Se n�o for atendido, quebramos o intervalo em dois e refinamos a 
    %quadratura. 
    lim{1,1} = pi; lim{1,2} = pm;
    [I1, pontos1] = multBQA(f, lim, L, eps, Iextref(1:3), [], dim);
    
    lim{1,1} = pm; lim{1,2} = pf;
    [I2, pontos2] = multBQA(f, lim, L, eps, Iextref(3:5), [], dim);
    
    %No final disso, somamos os valores j� refinados. 
    I = I1 + I2;
    pontos = [pontos; pontos1; pontos2];
end

end