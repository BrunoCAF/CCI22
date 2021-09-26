function [r, n] = PosicaoFalsa(f, a, b, epsilon, maxIteracoes)

% [r,n] = PosicaoFalsa(f,a,b,epsilon,maxIteracoes) determina uma aproximacao 
% para um zero contido no intervalo [a,b] da funcao f(x) utilizando o 
% Metodo da Posicao Falsa. O retorno da funcao eh a aproximacao r e o 
% numero de iteracoes n executadas. Considera-se para criterio de parada a 
% ocorrencia de uma das duas situacoes: |f(xi)| < epsilon ou 
% i > maxIteracoes, em que xi eh a aproximacao para a raiz na i-esima
% iteracao.
	r = 0;
	n = 0;
    
    while n < maxIteracoes
		% Implementar Metodo da Posicao Falsa
        r = (a*abs(f(b)) + b*abs(f(a)))/(abs(f(a)) + abs(f(b)));
        n = n + 1;
        
        if abs(f(r)) < epsilon
            break;
        end
        
        if f(a)*f(r) > 0
            a = r;
        elseif f(b)*f(r) > 0
            b = r;
        end
        
    end
end
