% given a matrix R and a collumn index j
% finds w and tau such that the householder reflexion
% H = I-tau*w*w’ put zeros below R(j,j)
% w will not be complete, it only has the lines j:end 
% because you do not need it to be complete! (think)
function [tau,w]=diagheiseholder(R,j)

normx = norm(R(j:end,j));
s = -sign(R(j,j));
u1 = R(j,j) - s*normx;
w = R(j:end,j)/u1;
w(1) = 1;
tau = -s*u1/normx;

end
