t = [0 0 0; 0 0 0];
%t guarda em cada linha e em cada coluna
%os tempos de execução de cada algoritmo
%para cada valor de N respectivamente

for n = 1:3
    N = 10^n;
    X = zeros(N, N);
    Y = zeros(N, N);
    Z = zeros(N, N);
    %Algoritmo 1
    tic;
    for i = 1:N
        for j = 1:N
            for k = 1:N
                Z(i, j) = X(i, k)*Y(k, j);
            end
        end
    end
    t(1, n) = toc;
   
    %Operador MATLAB
    tic;
    Z = X*Y;
    t(2, n) = toc;
    
end