function y = PassoRungeKutta4(f, h, x, y)
% y = PassoRungeKutta4(f, h, x, y) realiza um avanco com Metodo de 
% Runge-Kutta de ordem 4 a partir do ponto (x,y) com passo h. A funcao
% f eh a funcao derivada y'(x) = f(x, y).

k1 = f(x, y);
k2 = f(x + h / 2, y + h * k1 / 2);
k3 = f(x + h / 2, y + h * k2 / 2);
k4 = f(x + h, y + h * k3);

y = y + h * (k1 + 2 * k2 + 2 * k3 + k4) / 6;

end