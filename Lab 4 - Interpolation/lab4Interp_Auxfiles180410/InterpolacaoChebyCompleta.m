function [yq, p] = InterpolacaoChebyCompleta(x,y,xq)

%p = gChebyPolyInterp(x, y);
p = InterpolacaoChebyshev(x, y);
yq = polyval(p, xq);

end %func