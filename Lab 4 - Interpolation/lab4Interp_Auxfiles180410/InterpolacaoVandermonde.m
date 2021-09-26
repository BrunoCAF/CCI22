function [yq, p] = InterpolacaoVandermonde(x,y,xq)

p = PolinomioInterpolador(x, y);
yq = polyval(p, xq);

end %func