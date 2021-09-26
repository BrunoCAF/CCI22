function yq = InterpolacaoLinear(x, y, xq)
% yq = InterpolacaoLinear(x, y, xq) realiza interpolacao linear. Os 
% vetores coluna x = [x0,x1,...,xn]^T e y = [y0,y1,...,yn]^T sao os
% n + 1 nós de interpolacao. O vetor coluna xq contem os valores para os 
% quais se deseja calcular a interpolacao. A saida da funcao eh o vetor 
% coluna yq tal que yq(j) = p(xq(j)), em que p eh a funcao gerada pelas 
% funcoes afins construidas para cada segmento a partir dos n + 1 nos de 
% interpolacao.

n = length(x) - 1;
m = length(xq);

yq = zeros(size(xq));

for k = 1:m
    i = sum(xq(k) > x);
    if i < 1
        i = 1;
    elseif i > n
        i = n;
    end
    %x(i) < xq(k) < x(i+1)
    %| x(i)   y(i)  1|
    %|xq(k)  yq(k)  1| = 0
    %|x(i+1) y(i+1) 1|
    % yq(k)*(x(i) - x(i+1)) = xq(k)*(y(i) - y(i+1)) + x(i)y(i+1) - x(i+1)y(i)
    yq(k) = (xq(k)*(y(i) - y(i+1)) + x(i)*y(i+1) - x(i+1)*y(i))/(x(i) - x(i+1));
end

end