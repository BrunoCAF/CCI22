N = 100;
S = 100;

%Comparando a resolução de sistemas com a mesma matriz A
[A, b] = generateWellCond(S);

GTimes = zeros(N);
LUTimes = zeros(N);

for i = 1:N
    if i == 1
        tic;
        [L, U, P] = DecomposicaoLU(A);
        LUTimes(i) = LUTimes(i) + toc;
    end
    
    tic
    SolucaoLU(L, U, P, b);
    if i > 1
        LUTimes(i) = LUTimes(i-1) + toc;
    else
        LUTimes(i) = LUTimes(i) + toc;
    end
    
    tic
    SolucaoGauss(A, b);
    if i > 1
        GTimes(i) = GTimes(i-1) + toc;
    else
        GTimes(i) = GTimes(i) + toc;
    end
end

p0 = plot(1:10, LUTimes(1:10));
hold on;
p00 = plot(1:10, GTimes(1:10), 'r');
hold off;
legend({"Solução por decomposição LU", "Solução por eliminação Gaussiana"});
xlabel('Quantidade de sistemas resolvidos');
ylabel('Tempo (s)');
title('Comparação de desempenho: LU x Eliminação Gaussiana');
grid on;

print -dpng -r400 desempenhozoom.png;


figure;
p1 = plot(1:N, LUTimes);
hold on;
p2 = plot(1:N, GTimes, 'r');
hold off;
legend({"Solução por decomposição LU", "Solução por eliminação Gaussiana"});
xlabel('Quantidade de sistemas resolvidos');
ylabel('Tempo (s)');
title('Comparação de desempenho: LU x Eliminação Gaussiana');
grid on;

print -dpng -r400 desempenho.png;




%Comparando a resolução de sistemas com matrizes A diferentes
GTimes = zeros(N);
LUTimes = zeros(N);

for i = 1:N
    [A, b] = generateWellCond(S);
    
    tic;
    [L, U, P] = DecomposicaoLU(A);
    SolucaoLU(L, U, P, b);
    if i > 1
        LUTimes(i) = LUTimes(i-1) + toc;
    else
        LUTimes(i) = LUTimes(i) + toc;
    end
    
    tic
    SolucaoGauss(A, b);
    if i > 1
        GTimes(i) = GTimes(i-1) + toc;
    else
        GTimes(i) = GTimes(i) + toc;
    end
end

figure;
p3 = plot(1:N, LUTimes);
hold on;
p4 = plot(1:N, GTimes, 'r');
hold off;
legend({"Solução por decomposição LU", "Solução por eliminação Gaussiana"});
xlabel('Quantidade de sistemas resolvidos');
ylabel('Tempo (s)');
title('Comparação de desempenho com matrizes de coeficientes distintas');
grid on;

print -dpng -r400 desempenhodistintas.png;

% Gera uma matriz A aleatória bem condicionada de tamanho n x n
function [A,b] = generateWellCond(n)
A = rand(n);
b = rand(n,1);

while (cond(A)>1000)
    A = rand(n);
end

end

function [x,A,B] = SolucaoGauss(A,B)
[A,B] = EliminacaoGauss(A,B);
x = SolucaoTriangularSuperior(A,B);
end
