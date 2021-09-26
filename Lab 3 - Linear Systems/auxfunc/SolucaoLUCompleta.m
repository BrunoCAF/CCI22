function [x,L,U,P] = SolucaoLUCompleta(A,b)

[L,U,P] = DecomposicaoLU(A);

x = SolucaoLU(L, U, P, b);

end
