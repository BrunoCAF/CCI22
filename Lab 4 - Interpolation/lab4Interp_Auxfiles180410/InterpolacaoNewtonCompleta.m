function [yq, T] = InterpolacaoNewtonCompleta(x,y,xq)

T = TabelaDiferencasDivididas(x, y);
yq = InterpolacaoFormaNewton(T(1,:), x, xq);

end %func