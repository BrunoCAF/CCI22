function s = FuncaoCaixaPreta(n1, n2)
% Faz alguma conta ai... Para isso, usa uns numeros n1 e n2 ai...
% Dai da um resultado s ai...

s = 0;

for i=1:n1
    for j=1:n1
        for k=1:n2
            s = s + i * j * k;
        end
    end
end

end