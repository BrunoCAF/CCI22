function c = MinimosQuadrados(Phi, x, y)
% c = MinimosQuadrados(Phi, x, y) realiza ajuste de curva usando o Metodo
% dos Minimos Quadrados (MMQ). Os vetores coluna x = [x_1,x_2,...,x_m]^T
% e y = [y_1,y_2,...,y_m]^T representam os m pontos {(x_1,y_1),(x_2,y_2),
% ...,(x_m,y_m)} para os quais se deseja ajustar uma funcao f*(x) com 
% modelo:
% f*(x) = c_0 * Phi_0(x) + c_1 * Phi_1(x) + ... + c_n * Phi_n(x) = 
% c^T * Phi(x)
% em que Phi(x) = [Phi_0(x),Phi_1(x),...,Phi_n(x)]^T e c = [c_0,c_1,...,
% c_n]^T. No MMQ, determina-se c de modo a minimizar a seguinte funcao de
% custo:
% R(c) = sum_{i=1}^m (f*(x_i) - y_i)^2 =
% sum_{i=1}^m (c^T * Phi(x_i) - y_i)^2

n = length(Phi) - 1;

M = zeros(length(Phi), length(x));

for k = 1:n+1
    f = Phi{k};
    M(k, :) = (f(x))';
end
%(M*(M(1,:)'))'
%dR/dc0 = sum_{i=1}^m [M(1,i)*M(:,i)']*c = sum_{i=1}^m (y_i)(Phi_0(x_i))
%dR/dc1 = sum_{i=1}^m (c^T * Phi(x_i))(Phi_1(x_i)) = sum_{i=1}^m (y_i)(Phi_1(x_i))
%dR/dcj = sum_{i=1}^m (c^T * Phi(x_i))(Phi_j(x_i)) = sum_{i=1}^m (y_i)(Phi_j(x_i))
%dR/dcn = sum_{i=1}^m (c^T * Phi(x_i))(Phi_n(x_i)) = sum_{i=1}^m (y_i)(Phi_n(x_i))

A = M*M';
b = M*y;

c = linsolve(A, b);

end