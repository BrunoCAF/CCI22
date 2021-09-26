function [A,b] = generateLinhasOk(n)
A = rand(n);
b = rand(n,1);
while (~gCriterioLinhas(A) || (cond(A)>1000))
    A = rand(n);
    if (n > 4)
        A = 0.5*(A+A'); 
        %A = A + 0.5*n*eye(n);
    end
end

end%func