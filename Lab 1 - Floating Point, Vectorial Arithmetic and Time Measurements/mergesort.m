function res = mergesort(v)
%Assume vetores coluna
if size(v,1) < size(v,2)
    x = v';
else
    x = v;
end

if size(x,1) <= 1
    ord = x;
else
    mid = (size(x,1) + mod(size(x,1), 2))/2;
    x1 = mergesort(x(1:mid));
    x2 = mergesort(x(mid+1:end));
    ord = merge([x1; x2], mid);
end

%Retorna vetores com as dimensoes da entrada
if size(v,1) < size(v,2)
    res = ord';
else
    res = ord;
end

end

function ord = merge(x, mid)
    i = 1; %Percorrer a primeira metade
    j = mid+1; %Percorrer a segunda metade
    k = 1; %Percorrer o vetor auxiliar
    
    ord = zeros(size(x)); %Inicializa com zeros pra ganhar velocidade
    
    while i <= mid && j <= size(x,1)
        if x(i) < x(j)
            ord(k) = x(i);
            i = i + 1;
        else
            ord(k) = x(j);
            j = j + 1;
        end 
        k = k + 1;
    end
    
    while i <= mid
        ord(k) = x(i);
        i = i + 1;
        k = k + 1;
    end
    
    while j <= size(x,1)
        ord(k) = x(j);
        j = j + 1;
        k = k + 1;
    end
    
end