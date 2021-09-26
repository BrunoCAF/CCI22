% given a tridiagonal matrix, compute similarity transforms to 
% diagonalize the matriz, repeteadly applying Jacobi rotations
% until the diagonal matrix stabilizes. 
function [D,RR,niter] = cyclejacobi(T, tolerance)

if nargin < 2 % default tolerance
    tolerance = 1e-10;
end
niter = 0; % count iterations
n = length(T);
D = T; % input tridiagonal, output diagonal

RR = eye(n);
maxdiff = 1;% just to pass the first while
while(maxdiff > tolerance)
    prevD = D;% store last iteration
    for i=1:n 
        for j=i+1:n
            R = getJacobi(D,i,j); % get a jacobi rotation
            D = R'*D*R; % update
            RR = RR * R; % stores all Rs multiplied
        end%for
    end%for
    maxdiff = max( max(abs(prevD - D)));% run until D stops changing
    niter = niter + 1;% next iteration
end%while

end %cyclejacobi

% useful only to consecutive rotation, not general case
function theta = getTheta(T,c)
t = T(c,c);
u = T(c,c+1);
v = T(c+1,c+1);
theta = atan(  ((t-v) + sqrt((t-v)^2 + 4*u^2) )/(2*u) );
end

% generates rotation matrix given angle.
% was usefull as a debug tool, not in final algorithm
function R = getR(theta)
R = [cos(theta) sin(theta) ; -sin(theta) cos(theta)];
end%