function T = MedirTempoFuncaoCaixaPreta(x1, x2)
% Mede o tempo da FuncaoCaixaPreta com argumentos x1 e x2 e retorna este
% tempo de execucao na variavel T.

T = zeros(length(x1), 1);

Nt = 30;

for i=1:length(x1)
    tic;
    for j=1:Nt
        s = FuncaoCaixaPreta(x1(i), x2(i));
    end
    T(i) = toc / Nt;
end

end