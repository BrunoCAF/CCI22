%Grau do Polinômio de Bernstein
N = 30;

%Função a ser aproximada
f = @(x) (1./(1 + 25*x.^2));

%Gerar a base de polinômios de Bernstein até o grau N
[P, B] = bernstein(N);

%Guardar os polinõmios associados à função de graus 0 até N
P{1, 1} = ones(1,1);

for n = 1:N
    P{1, n+1} = B{n+1,1}*f(0/n);
    for i = 1:n
        P{1, n+1} = P{1, n+1} + B{n+1,i+1}*f(i/n);
    end
end


hold on;
t = 0:0.001:1;
plot(t, f(t), 'k:');
for n = 0:N
    plot(t, polyval(P{1, n+1}, t));
end
axis([0 1 0 1]);


figure;
hold on;
t = 0:0.001:1;
plot(t, f(t), 'k:');
plot(t, polyval(P{1, N+1}, t));
axis([0 1 0 1]);

