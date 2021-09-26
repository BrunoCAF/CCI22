%Vamos mostrar que os algoritmos
%MergeSort e BubbleSort implementados
%de fato funcionam para vetores grandes

N = 10^4;

x = rand(1, N);

figure;
hold on;
plot(1:N, x, 'r');%Plotando o vetor desordenado
plot(1:N, mergesort(x), 'b');%Plotando o vetor já ordenado
xlabel('Posição do Elemento');
ylabel('Valor do Elemento');
legend('Vetor desordenado', 'Vetor ordenado', 'Location', 'north');
title('Ordenação MergeSort');
grid on;
grid minor;
axis fill;

print -dpng -r400 mergefuncionando.png;


x = rand(1, N);

figure;
hold on;
plot(1:N, x, 'r');%Plotando o vetor desordenado
plot(1:N, bubblesort(x), 'b');%Plotando o vetor já ordenado
xlabel('Posição do Elemento');
ylabel('Valor do Elemento');
legend('Vetor desordenado', 'Vetor ordenado', 'Location', 'north');
title('Ordenação BubbleSort');
grid on;
grid minor;
axis fill;

print -dpng -r400 bubblefuncionando.png;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Agora vamos estudar a variação do tempo de 
%execução com o tamanho da entrada

%Vamos utilizar N = 10^4 para evidenciar o aspecto quadrático
%do BubbleSort, e o aspecto O(n log n) do MergeSort

%Vamos criar vários vetores aleatórios e ordenar pedaços de tamanhos
%crescentes de cada vetor, e ao final realizar uma média dos tempos
%para ordenar as partes de cada um dos vetores, de modo a reduzir
%o ruído nas medidas de tempo de execução dos algoritmos
x = rand(100, N);

tempoMerge = zeros(10,N/50);
tempoBubble = zeros(10,N/50);
tempoMATLAB = zeros(10,N/50);

for tamanho = 50:50:N
    for i = 1:10
        tic;
        mergesort(x(i, 1:tamanho));
        tempoMerge(i, tamanho/50) = toc;
    
        tic;
        bubblesort(x(i, 1:tamanho));
        tempoBubble(i, tamanho/50) = toc;
    
        tic;
        sort(x(i, 1:tamanho));
        tempoMATLAB(i, tamanho/50) = toc;     
    end
end

figure;
hold on;
plot(50:50:N, mean(tempoMerge, 1), 'r');
plot(50:50:N, mean(tempoBubble, 1), 'b');
plot(50:50:N, mean(tempoMATLAB, 1), 'g');
xlabel('Tamanho do Vetor');
ylabel('Tempo de Execução');
legend('MergeSort', 'BubbleSort', 'MATLAB', 'Location', 'north');
title('Tempo Ordenação');
grid on;
grid minor;
axis fill;

print -dpng -r400 tempodeordenacao10000.png;

maxtime = [max(mean(tempoMerge, 1)); max(mean(tempoBubble, 1)); max(mean(tempoMATLAB, 1))];

%Vamos agora olhar para tamanhos de entrada menores para identificar
%o ponto onde o Merge se torna melhor que o Bubble

N = 1000;

tempoMerge = zeros(100,N/5);
tempoBubble = zeros(100,N/5);
tempoMATLAB = zeros(100,N/5);

for tamanho = 5:5:N
    for i = 1:100
        tic;
        mergesort(x(i, 1:tamanho));
        tempoMerge(i, tamanho/5) = toc;
    
        tic;
        bubblesort(x(i, 1:tamanho));
        tempoBubble(i, tamanho/5) = toc;
    
        tic;
        sort(x(i, 1:tamanho));
        tempoMATLAB(i, tamanho/5) = toc;     
    end
end

figure;
hold on;
plot(5:5:N, mean(tempoMerge, 1), 'r');
plot(5:5:N, mean(tempoBubble, 1), 'b');
plot(5:5:N, mean(tempoMATLAB, 1), 'g');
xlabel('Tamanho do Vetor');
ylabel('Tempo de Execução');
legend('MergeSort', 'BubbleSort', 'MATLAB', 'Location', 'north');
title('Tempo Ordenação');
grid on;
grid minor;
axis fill;

print -dpng -r400 tempodeordenacao1000.png;


