function res = mysortrows(A)

med = int32(size(A,1)/2); %Arredonda pra cima

A1 = MergeSort(A(1:med, :)); %Ordena a metade de cima
A2 = MergeSort(A(med+1:end, :)); %Ordena a metade de baixo
res = Merge([A1; A2], med); %Junta as duas

end

function res = MergeSort(M)

if size(M,1) == 1
    res = M; %Se chegar numa matriz linha, ja esta ordenado
else
    med = int32(size(M, 1)/2);
    M1 = MergeSort(M(1:med, :));
    M2 = MergeSort(M(med+1:end, :));
    res = Merge([M1; M2], med);
end

end

function res = Merge(M, med)
    %M(1:med, :) é a matriz M1;
    %M(med+1:end, :) é a matriz M2;
    
    %med é o "end" para M1;
    %size(M,1) é o "end" para M2;
    
    i = 1; %Percorrer a primeir metade
    j = med+1; %Percorrer a segunda metade
    k = 1; %Percorrer a matriz auxiliar
    
    res = zeros(size(M)); %Inicializa com zeros pra ganhar velocidade
    
    while i <= med && j <= size(M,1)
        if comparaLinhas(M, i, j)
            res(k, :) = M(i, :);
            i = i + 1;
        else
            res(k, :) = M(j, :);
            j = j + 1;
        end 
        k = k + 1;
    end
    
    while i <= med
        res(k, :) = M(i, :);
        i = i + 1;
        k = k + 1;
    end
    
    while j <= size(M,1)
        res(k, :) = M(j, :);
        j = j + 1;
        k = k + 1;
    end
    
end

function res = comparaLinhas(M, i, j)
    
    t = 1; 
    while (M(i, t) == M(j, t)) && (t < size(M,2))
        t = t + 1; %Avanca o indice ate encontrar o primeiro desempate (ou nao encontrar)
    end

    res = (M(i, t) < M(j, t)); %Retorna o valor logico do desempate
    
end