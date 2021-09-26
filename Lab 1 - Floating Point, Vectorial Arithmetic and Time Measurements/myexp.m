function [e,relerr] = myexp(x)

	%calcule o exp(x) usando a serie
	%calcule o erro relativo. 
    %use a funcao exp() do matlab para comparar
	
    e = double(1.0);   
    for i = 500:-1:1
        e = e*(x/i) + 1; % Metodo de Horner
    end
    
    relerr = abs(exp(x) - e)/e;

    fprintf('%.15f\n%.15f', e, relerr);
end