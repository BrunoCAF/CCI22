size = 10^7;

t = 1:1000;
t1 = t;
t2 = t;

for i = 1:1000
%Para o metodo 1
    x = rand(size, 1);
    y = rand(size, 1);
    pi = 0;
    tic;
    pi = x' * y;
    t1(i) = toc;
    
%Para o metodo 2
    pi = 0;
    tic;
    for j = 1:size
        pi = pi + x(j)*y(j);
    end
    t2(i) = toc;

end

figure;
hold on;
plot(t, t1, 'r');
xlabel('Operação');
ylabel('Tempo (s)');
legend('Método 1');
title('Tempos para calcular produto interno pelo Método 1');
grid on;
grid minor;
axis fill;

print -dpng -r400 tempos1.png;

figure;
hold on;
plot(t, t2, 'g');
xlabel('Operação');
ylabel('Tempo (s)');
legend('Método 2');
title('Tempos para calcular produto interno pelo Método 2');
grid on;
grid minor;
axis fill;

print -dpng -r400 tempos2.png;


T1 = zeros(1, 1000);
T2 = zeros(1, 1000);
for i = 1:1000
    T1(i) = mean(t1(1:i));
    T2(i) = mean(t2(1:i));
end

figure;
hold on;
plot(t, T1, 'r');
xlabel('Quantidade de medidas');
ylabel('Tempo Médio (s)');
legend('Método 1');
title('Média dos tempos para o Método 1');
grid on;
grid minor;
axis fill;

print -dpng -r400 medias1.png;

figure;
hold on;
plot(t, T2, 'g');
xlabel('Quantidade de medidas');
ylabel('Tempo Médio (s)');
legend('Método 2');
title('Média dos tempos para o Método 2');
grid on;
grid minor;
axis fill;

print -dpng -r400 medias2.png;