% troca linha l1 e l2 da matriz A

%A = trocaL(A,l1,l2)

function A = trocaL(A,l1,l2)

    aux = A(l1,:);

    A(l1,:) = A(l2,:);

    A(l2,:) = aux;

end