function y = PassoAdamsBashforth4(fv, h, y)
% y = PassoAdamsBashforth4(fv, h, y) realiza um avanco com Metodo de 
% Adams-Bashforth de ordem 4 a partir do ponto y com passo h. A matriz fv
% contem os valores da funcao derivada necessarios para o calculo:
% fv(4,:) = f(x(i), y(i,:))
% fv(3,:) = f(x(i-1), y(i-1,:))
% fv(2,:) = f(x(i-2), y(i-2,:))
% fv(1,:) = f(x(i-3), y(i-3,:))

y = y + h * (55 * fv(4,:) - 59 * fv(3,:) + 37 * fv(2,:) - 9 * fv(1,:)) / 24;

end