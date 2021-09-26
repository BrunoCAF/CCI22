function [c, r] = RegressaoLinear(x, y)
% [c, r] = RegressaoLinear(x, y) realiza Regressao Linear de modo a obter 
% a melhor reta que aproxima os pontos m pontos {(x_1,y_1),(x_2,y_2),...,
% (x_m,y_m)} no sentido de minimos quadrados. Assim, tem-se um caso 
% particular de MMQ em que o modelo para f*(x) e: 
% f*(x) = c_0 + c_1 * x = c^T [1; x]
% em que c = [c_0,c_1]^T. Alem disso, a funcao calcula o coeficiente de 
% correlacao r como estimativa da qualidade do ajuste:
% r = sqrt((R_M-R)/R_M)
%em que:
% R = sum_{i=1}^m (f*(x_i) - y_i)^2 = sum_{i=1}^m (c_0+c_1*x_i-y_i)^2
% R_M = sum_{i=1}^m [((sum_{i=1}^m y_i)/m) - y_i]^2

m = length(x);

c = [0;0];
S = [x'*x, x'*y, sum(x), sum(y)];

c(1) = (S(1)*S(4) - S(3)*S(2))/(m*S(1) - S(3)*S(3));
c(2) = (m*S(2) - S(3)*S(4))/(m*S(1) - S(3)*S(3));

R = sum((c(1) + c(2)*x - y).^2);
ym = sum(y)/m;
Rm = sum((ym - y).^2);

r = sqrt(1 - R/Rm);

end