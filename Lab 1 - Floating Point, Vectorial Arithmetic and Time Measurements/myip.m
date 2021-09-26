size = 10^6;

t = 1:1000;
%Para o metodo 1
for i = 1:1000
    x = rand(size, 1);
    y = rand(size, 1);
    pi = 0;
    tic;
    pi = x' * y;
    t1(i) = toc;
    
%Para o metodo 2
    pi = 0;
    tic;
    pi = dot(x,y);
    t2(i) = toc;

%Para o metodo 3
    pi = 0;
    tic;
    for j = 1:size
        pi = pi + x(j)*y(j);
    end
    t3(i) = toc;
end

figure;
hold on;
plot(t, t1, 'r');
xlabel('Opera��o');
ylabel('Tempo (s)');
legend('M�todo 1');
title('Tempos para calcular produto interno pelo M�todo 1');
grid on;
grid minor;
axis fill;

print -dpng -r400 tempos1.png;

figure;
hold on;
plot(t, t2, 'g');
xlabel('Opera��o');
ylabel('Tempo (s)');
legend('M�todo 2');
title('Tempos para calcular produto interno pelo M�todo 2');
grid on;
grid minor;
axis fill;

print -dpng -r400 tempos2.png;

figure;
hold on;
plot(t, t3, 'b');
xlabel('Opera��o');
ylabel('Tempo (s)');
legend('M�todo 3');
title('Tempos para calcular produto interno pelo M�todo 3');
grid on;
grid minor;
axis fill;

print -dpng -r400 tempos3.png;

time_mean = zeros(3, 1000);
for i = 1:1000
    time_mean(1, i) = mean(t1(1:i));
    time_mean(2, i) = mean(t2(1:i));
    time_mean(3, i) = mean(t3(1:i));
end

figure;
hold on;
plot(t, time_mean(1, :), 'r');
xlabel('Quantidade de medidas');
ylabel('Tempo M�dio (s)');
legend('M�todo 1');
title('M�dia dos tempos para o M�todo 1');
grid on;
grid minor;
axis fill;

print -dpng -r400 medias1.png;

figure;
hold on;
plot(t, time_mean(2, :), 'g');
xlabel('Quantidade de medidas');
ylabel('Tempo M�dio (s)');
legend('M�todo 2');
title('M�dia dos tempos para o M�todo 2');
grid on;
grid minor;
axis fill;

print -dpng -r400 medias2.png;

figure;
hold on;
plot(t, time_mean(3, :), 'b');
xlabel('Quantidade de medidas');
ylabel('Tempo M�dio (s)');
legend('M�todo 3');
title('M�dia dos tempos para o M�todo 3');
grid on;
grid minor;
axis fill;

print -dpng -r400 medias3.png;

time_mean(:, end)

