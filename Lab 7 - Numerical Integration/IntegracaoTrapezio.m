function I = IntegracaoTrapezio(h, y)
% I = IntegracaoSimpson(h, y): usando a Regra Composta dos Trapezios, 
% calcula uma aproximacao para a integral:
%
% I = \int_a^b f(x) dx
%
% Considera-se n+1 pontos {x_0=a,x_1,...,x_n=b} igualmente espacados no
% intervalo de integracao [a,b]. No caso, o espacamento entre dois pontos
% consecutivos eh h = x_{i} - x_{i-1} = (b - a) / n. As entradas da funcao
% sao h e o vetor coluna y = [y_0,y_1,...,y_n]^T, em que y_i = f(x_i),
% i=0,1,...,n.
I = h*(sum(y) - (y(1) + y(end))/2);

end