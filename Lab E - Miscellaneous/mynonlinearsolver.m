function [sol] = mynonlinearsolver(F,x0) 

% get F(x,y) and J(x,y)
[fxy,Jxy] = F(x0');

% fake solution, just to show output format: delete this
% note: sol is x0 + a vector
% so it is a sequence of intermediate solutions, the last one is final
epsilon = 10^-20;
maxIteracoes = 1000;

x = zeros(maxIteracoes,2);
x(1, :) = x0';

k = 1;

while max(abs(fxy)) >= epsilon
    x(k+1,:) = x(k,:) - ( Jxy \ fxy' )';
    if k + 1 > maxIteracoes    
        break;
    end
    k = k + 1;
    [fxy,Jxy] = F(x(k,:));
    
end

sol = x(1:k, :);

end
%func