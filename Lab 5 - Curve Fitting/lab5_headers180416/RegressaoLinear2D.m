function c = RegressaoLinear2D(x1, x2, y)
% c = RegressaoLinear2D(x1, x2, y) realiza Regressao Linear com duas 
% variaveis independentes x_1 e x_2. Os vetores coluna x_1 = [x_{11},
% x_{12},...,x_{1m}]^T, x_2 = [x_{21},x_{22},...,x_{2m}]^T e y = 
% [y_1,y_2,...,y_m]^T representam os m pontos {(x_{1i},x_{2i},y_i)},
% i=1,...,m para os quais se deseja ajustar uma funcao de duas variaveis
% f*(x_1,x_2) que define um plano no R^3:
% f*(x_1,x_2) = c_0 + c_1 x_1 + c_2 x_2
% Assim, a funcao determina c = [c_0,c_1,c_2]^T que minimiza a seguinte 
% funcao de custo:
% R(c_0,c_1) = sum_{i=1}^m (f*(x_i) - y_i)^2 = 
% sum_{i=1}^m (c_0 + c_1 * x_{1i} + c_2 * x_{2i} - y_i)^2

m = length(y);

c = [0;0;0];
S = [x1'*x1, x1'*x2, x2'*x2, sum(x1), sum(x2), x1'*y, x2'*y, sum(y)];
D1 = S(8)*S(1)*S(3) + S(4)*S(2)*S(7) + S(5)*S(6)*S(2) - S(7)*S(1)*S(5) - S(2)*S(2)*S(8) - S(3)*S(6)*S(4);
D2 = m*S(6)*S(3) + S(8)*S(2)*S(5) + S(5)*S(4)*S(7) - S(5)*S(6)*S(5) - S(7)*S(2)*m - S(3)*S(4)*S(8);
D3 = m*S(1)*S(7) + S(4)*S(6)*S(5) + S(8)*S(4)*S(2) - S(5)*S(1)*S(8) - S(6)*S(2)*m - S(7)*S(4)*S(4);
D = m*S(1)*S(3) + 2*S(4)*S(2)*S(5) - S(1)*S(5)*S(5) - S(3)*S(4)*S(4) - m*S(2)*S(2);

% m   S(4)  S(5) | S(8)
%S(4) S(1)  S(2) | S(6)
%S(5) S(2)  S(3) | S(7)

c(1) = D1/D;
c(2) = D2/D;
c(3) = D3/D;

end