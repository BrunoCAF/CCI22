% perform interpolation with csape (spline)
% parameter method, optional, defaut is 'variational'
% function [yq, pp] = InterpolacaocsapeCompleta(x,y,xq,method)
function [yq, pp] = InterpolacaocsapeCompleta(x,y,xq,method)
if nargin < 4
   method =  'variational';
end

pp = csape(x, y, method);
yq = ppval(pp, xq);%% pp is piecewise polynomial
% try to see what is in pp, it is a vector of structs


end %func