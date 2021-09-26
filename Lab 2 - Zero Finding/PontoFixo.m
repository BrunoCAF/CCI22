function [r, n] = PontoFixo(f, g, x0, epsilon, maxIteracoes)
% [r,n] = PontoFixo(f,g,x0,epsilon,maxIteracoes) determina um zero da 
% funcao f(x) a partir do chute inicial x0 utilizando o Metodo do Ponto 
% Fixo com funcao de iteracao g(x). O retorno da funcao eh a aproximacao 
% r e o numero de iteracoes n executadas. Considera-se para criterio de 
% parada a ocorrencia de uma das duas situacoes: |f(xi)| < epsilon ou 
% i > maxIteracoes, em que xi é a aproximacao para a raiz na i-esima 
% iteracao.

r = x0;
n = 0;

while n < maxIteracoes
    r = g(r);
    n = n + 1;
    if abs(f(r)) < epsilon
        break;
    end
end

end