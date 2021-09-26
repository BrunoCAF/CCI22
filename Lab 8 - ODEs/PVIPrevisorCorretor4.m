function y = PVIPrevisorCorretor4(f, x, y0)
% y = PVIPrevisorCorretor4(f, x, y0) utiliza um Metodo de Previsao-Correcao 
% para resolver o  problema de valor inicial (PVI) associado ao sistema de 
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
%
% A funcao utiliza o Metodo de Adams-Bashforth de ordem 4 como previsor e 
% o Metodo de Adams-Moulton de ordem 4 como corretor. Apenas um passo de 
% correcao eh realizado. Para inicializar o metodo de passo multiplo, a 
% funcao utiliza o Metodo de Runge-Kutta de ordem 4.

n = length(x);
l = size(y0, 2);

y = zeros(n, l);
fv = zeros(n, l);

y(1,:) = y0;
h = x(2) - x(1);

for i=1:3
    % Usar Runge-Kutta de ordem 4 para inicializar o metodo de passo
    % multiplo
    y(i+1,:) = PassoRungeKutta4(f, h, x(i), y(i,:));
end


fv(1,:) = f(x(1), y(1,:));
fv(2,:) = f(x(2), y(2,:));
fv(3,:) = f(x(3), y(3,:));
for i=4:(n-1)
    % Resolver o restante do PVI com Metodo de Previsao-Correcao usando
    % 1 passo de Adams-Bashforth de ordem 4 (previsao) e 1 passo de
    % Adams-Moulton de ordem 4 (correcao)
    % Previs�o
    fv(i,:) = f(x(i), y(i,:));
    y(i+1,:) = PassoAdamsBashforth4(fv(i-3:i, :), h, y(i,:))
    
    % Corre��o
    fv(i+1,:) = f(x(i+1), y(i+1,:));
    y(i+1,:) = PassoAdamsMoulton4(fv(i-2:i+1, :), h, y(i,:));
end

end