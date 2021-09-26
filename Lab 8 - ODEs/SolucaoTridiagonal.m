function x = SolucaoTridiagonal(a, b, c, d)
% x = SolucaoTridiagonal(a, b, c, d) utiliza o algoritmo de Thomas, cuja 
% complexidade eh O(n), para resolver um sistema tridiagonal na seguinte 
% forma:
% a_i x_{i-1} + b_i x _i + c_i x_{i+1} = d_i, i=1,2,...,n 
% Em que a1 = cn = 0. Ou em representacao matricial:
% [ b1,  c1,  0,   0,   0,   ..., 0,    0    ] [ x1   ] = [ d1   ]
% [ a2,  b2,  c2,  0,   0,   ..., 0,    0    ] [ x2   ]   [ d2   ]
% [ 0,   a3,  b3,  c3,  0,   ..., 0,    0    ] [ x3   ]   [ d3   ]
% [ 0,   0,   a4,  b4,  c4,  ..., 0,    0    ] [ x4   ]   [ d4   ]
% [ 0,   0,   0,   a5,  b5,  ..., 0,    0    ] [ x5   ]   [ d5   ]
% [ ..., ..., ..., ..., ..., ..., 0,    0    ] [ ...  ]   [ ...  ]
% [ 0,   0,   0,   0,   0,   ..., bn-1, cn-1 ] [ xn-1 ]   [ dn-1 ]
% [ 0,   0,   0,   0,   0,   ..., an,   bn   ] [ xn   ]   [ dn   ]
% As entradas da funcao sao os vetores coluna a = [a1,a2,...,an]^T, 
% b = [b1,b2,...,bn]^T, c = [c1,c2,...,cn]^T e d = [d1,d2,...,dn]^T, 
% enquanto a saida eh o vetor coluna x = [x1,x2,...,xn]^T.

n = length(a);

x = zeros(n, 1);

c(1) = c(1) / b(1);
d(1) = d(1) / b(1);

for i=2:n
    c(i) = c(i) / (b(i) - a(i) * c(i-1));
    d(i) = (d(i) - a(i) * d(i-1)) / (b(i) - a(i) * c(i-1));
end

x(n) = d(n);
for i=(n-1):-1:1
    x(i) = d(i) - c(i) * x(i+1);
end

end