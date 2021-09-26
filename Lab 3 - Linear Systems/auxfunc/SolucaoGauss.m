function [x,A,B] = SolucaoGauss(A,B)

[A,B] = EliminacaoGauss(A,B);

x = SolucaoTriangularSuperior(A,B);

end
