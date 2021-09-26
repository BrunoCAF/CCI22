function [r, n] = Secante(f, x0, x1, epsilon, maxIteracoes)

% [r,n] = Secante(f,x0,x1,epsilon,maxIteracoes) determina um zero da 
% funcao f(x) a partir dos chutes iniciais x0 e x1 utilizando o Metodo 
% da Secante. O retorno da funcao eh a aproximacao r e o numero de 
% iteracoes n executadas. Considera-se para criterio de parada a 
% ocorrencia de uma das duas situacoes: |f(xi)| < epsilon ou 
% i > maxIteracoes, em que xi eh a aproximacao para a raiz na i-esima
% iteracao.
	
    r = 0;
    n = 0;

    while n < maxIteracoes
		% Implementar Metodo da Secante
        r = x1 - (x1 - x0)*f(x1)/(f(x1) - f(x0));
        n = n + 1;        
        if abs(f(r)) < epsilon
            break;
        end
        x0 = x1;
        x1 = r; 
    end
end
