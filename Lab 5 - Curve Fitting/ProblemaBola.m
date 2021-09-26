clear;

g = 9.8;
load bolinha.mat;

% ln(T'*g/2) = ln(v0) + i*ln(e) <=> y = a + b*x
i = (1:length(Tp))';

[c, rfit] = RegressaoLinear(i, log(Tp*g/2));
v0 = exp(c(1)); epsilon = exp(c(2));
% epsilon = 0.899364048551552
%    v0   = 1.009390211248604

%Para checar, vamos obter os parâmetros 
%a partir das medidas sem ruído. 
[c, rexact] = RegressaoLinear(i, log(T*g/2));
finerv0 = exp(c(1)); finerepsilon = exp(c(2));
% epsilon = 0.900000000000000
%    v0   = 1.000000000000000
% rexact  = 1.000000000000000

figure();
hold on;
plot(i, T, 'r', 'LineWidth', 1);
plot(i, Tp, 'g*');
plot(i, (epsilon.^i)*v0*2/g, 'b', 'LineWidth', 1);
xlabel('Ordem');
ylabel('Tempo');
legend('Tempo real', 'Pontos com ruido', 'Tempo ajustado');
title(sprintf('Ajuste dos tempos de quique da bolinha | r = %s', rfit));
grid on;
grid minor;
axis fill;

print -dpng -r400 problemabola.png


stdepsilon = 0.95;
stdv0 = 2.0;
N = 5;
s = 0.01:0.01:0.1;
r = zeros(size(s'));

for i = 1:length(s)
    for k = 1:1000
        [newT, newTp] = SimularBola(stdepsilon, stdv0, N, s(i));
        [~, rk] = RegressaoLinear((1:N)', log(newTp*g/2));
        r(i) = r(i) + rk;
    end
    r(i) = r(i)/1000;
end

figure();
hold on;
plot(s, r, 'b-', s, r, 'r.');
xlabel('Amplitude do ruído - s');
ylabel('Coeficiente de correlação - r');
title('Qualidade do ajuste linear em função da amplitude do ruído');
grid on;
grid minor;
axis tight;

print -dpng -r400 problemabola2.png