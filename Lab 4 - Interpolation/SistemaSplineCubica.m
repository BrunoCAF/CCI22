function [a, b, c, d] = SistemaSplineCubica(x, y)
% [a, b, c, d] = SistemaSplineCubica(x, y) monta o sistema tridiagonal 
% associado ao metodo Spline Cubica.
% As entradas sao os vetores coluna x = [x0,x1,...,xn]^T e 
% y = [y0,y1,...,yn]^T, que representam os n + 1 nos de interpolacao. Ja as
% saidas sao os vetores coluna a = [a1,a2,...,an-1]^T, b = [b1,b2,...,bn-1]^T,
% c = [c1,c2,...,cn-1]^T e d = [d1,d2,...,dn-1]^T, que representam o sistema 
% tridiagonal que se deseja construir na notacao requerida pela funcao
% SolucaoTridiagonal.

h = diff(x);

n = length(h);
    
a = h(1:n-1);
c = h(2:n);
b = 2*(a+c);
a(1) = 0;
c(end) = 0;

v = diff(y);
v = v./h;
d = 6*diff(v);

end
