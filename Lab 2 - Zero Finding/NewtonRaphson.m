function [r, n] = NewtonRaphson(f, df, x0, epsilon, maxIteracoes)

% [r,n] = NewtonRaphson(f,df,x0,epsilon,maxIteracoes) determina um zero da 
% funcao f(x) a partir do chute inicial x0 utilizando o Metodo de 
% Newton-Raphson com funcao derivada f'(x) = df(x). O retorno da funcao eh 
% a aproximacao r e o numero de iteracoes n executadas. Considera-se para 
% criterio de parada a ocorrencia de uma das duas situacoes: 
% |f(xi)| < epsilon ou i > maxIteracoes, em que xi é a aproximacao
% para a raiz na i-esima iteracao.
    r = x0;
    n = 0;

    while n < maxIteracoes
		% Implementar Metodo de Newton-Raphson
        r = r - f(r)/df(r);
        n = n + 1;
        if abs(f(r)) < epsilon
            break;
        end
    end
end
