function y = PVIRungeKutta4(f, x, y0)
% y = PVIEuler(f, x, y0) utiliza o Metodo de Runge-Kutta de 4a ordem para 
% resolver o  problema de valor inicial (PVI) associado ao sistema de 
% equacoes diferenciais ordinarias (EDOs) p'(t) = f(t, p) e a condicao 
% inicial p(t_0=a) = y_0, no intervalo [a = x_0, b = x_n]. A solucao eh 
% calculada nos pontos contidos no vetor coluna 
% x = [x_0,x_1,x_2,...,x_n]^T, em que h = x_{i+1} - x_i (i.e. considera-se
% pontos igualmente espacados no intervalo [a, b]. A funcao vetorial 
% f(t, p) eh definida como um vetor linha:
%
% f(t, p) = [f_1(t, p) f_2(t, p) ... f_l(t, p)]
%
% em que:
%
% p(t) = [p_1(t) p_2(t) ... p_l(t)]
%
% Desse modo, o retorno da funcao eh a matriz y definida da seguinte forma:
% 
% y = 
% [p(x_0)]   [p_1(x_0) p_2(x_0) ... p_l(x_0)]
% [p(x_1)]   [p_1(x_1) p_2(x_1) ... p_l(x_1)]
% [p(x_2)] = [p_1(x_2) p_2(x_2) ... p_l(x_2)]
% [ ...  ]   [  ...      ...    ...   ...   ]
% [p(x_n)]   [p_1(x_n) p_2(x_n) ... p_l(x_n)]

n = length(x);
l = length(y0);

y = zeros(n, l);

y(1,:) = y0;

% Implementar Metodo de Runge-Kutta de 4a ordem

ordem = 4;
k = zeros(ordem, l);

h = x(2) - x(1);

for i = 2:n
    k(1,:) = f(x(i-1), y(i-1,:));
    k(2,:) = f(x(i-1)+h/2, y(i-1,:)+h*k(1,:)/2);
    k(3,:) = f(x(i-1)+h/2, y(i-1,:)+h*k(2,:)/2);
    k(4,:) = f(x(i-1)+h, y(i-1,:)+h*k(3,:));
    
    y(i,:) = y(i-1, :) + h*([1,2,2,1]*k)/6;
end

end