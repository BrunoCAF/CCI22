function [T, Tp] = SimularBola(epsilon, v0, N, s)
% Simula a bolinha de THBall do Saraiva usando os seguintes parametros:
% epsilon: coeficiente de restituicao
% v0: velocidade inicial
% N: numero de choques simulados
% s: amplitude do ruido de medida
% Retorna os tempos entre os choques. T contem os tempos reais, enquanto 
% Tp contem os tempos medidos pelo Saraiva.

g = 9.8;

T = zeros(N, 1);
Tp = zeros(N, 1);

if N == 0
    return;
end

T(1) = epsilon * (2 * v0 / g);

for i = 2:N
    T(i) = epsilon * T(i-1);
end

xi = s * 2 * (rand(N, 1) - 0.5);
Tp = max(0, T + xi);

end