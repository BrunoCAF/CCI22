function [yq, ipoly] = InterpolacaoFormaNewton(dd, x, xq)
% yq = InterpolacaoFormaNewton(dd, x, xq) calcula os valores interpolados 
% y_q = p_n(x_q) utilizando polinômio interpolador p_n(x) na Forma de 
% Newton. O vetor dd = [f[x_0],f[x_0,x_1],...,f[x_0,x_1,...,x_n]] 
% contém os operadores diferenças divididas necessários para o cálculo e 
% x = [x_0,x_1,...,x_n]' são os n + 1 pontos de interpolação. No caso de 
% x_q ser um vetor, y_q é um vetor tal que y_q(i) = p_n(x_q(i)). Neste
% caso, x_q e y_q são vetores coluna.
%
% ipoly (saida): o polinomio interpolador na forma de polyval

n = length(x) - 1; 
% length toma a maior dimensao, nao precisa saber a dimensao ? em size(x,?)

% Calcular interpolação usando Forma de Newton
fat = zeros(n+1);
fat(1,n+2-1:end) = 1; %Tabela de produtos de fatores (x-x0)(x-x1)...(x-xn)
for k = 2:n+1
    fat(k,n+2-k:end) = conv(fat(k-1,n+2-k+1:end),[1 -x(k-1)]);
end

ipoly = dd*fat;

yq = polyval(ipoly, xq); % retorne a resposta correta.

end

% calculates the sum of 2 polynomials
% p1,p2, and return ps are polynomials in polyval() vector form
function ps = sumpoly(p1,p2)
    ml = max(length(p1),length(p2));
    p1 = [ zeros(1,ml - length(p1)) p1 ]; % fill vectors with zeros
    p2 = [ zeros(1,ml - length(p2)) p2 ];
    ps = p1+p2;
end