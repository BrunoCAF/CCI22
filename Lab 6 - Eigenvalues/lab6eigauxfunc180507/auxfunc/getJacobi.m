% returns a jacobi rotation even if l and c are not consecutive
% https://en.wikipedia.org/wiki/Jacobi_rotation
function R = getJacobi(T,l,c)
dmin = min(l,c);
dmax = max(l,c);

all = T(dmax,dmax);% right-down = all
akk = T(dmin,dmin);% left-up = akk;
akl = T(l,c);      % off-diagonal = akl
%https://en.wikipedia.org/wiki/Jacobi_rotation
beta = (all - akk)/(2*akl);
t = sign(beta)/(abs(beta)+sqrt(beta^2+1));
c = 1 / sqrt(t^2 + 1);
s = c * t;

R = eye(length(T));
R(dmin,dmin) = c;%cos(theta);
R(dmin,dmax) = s;%sin(theta);
R(dmax,dmin) = -s;%-sin(theta);
R(dmax,dmax) = c;%cos(theta);
end
