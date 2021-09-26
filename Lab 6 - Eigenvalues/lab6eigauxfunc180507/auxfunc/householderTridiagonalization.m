% given a symetric real matrix
% tridiagonalizes it via successive householder transformations
% returns:
% M tridiagonal matrix
% PP the similarity transformation such that PP*M*PP = A
% allA: all intermediate steps for A
% allP: all intermediate transformations such that
%       Plast * ... * P2 * P1 = PP
% allA and allP are usefull if you want to print all steps
function [M,PP,allA,allP] = householderTridiagonalization(A)
[n,c] = size(A);
assert(isequal(n,c),'A is not square');
%assert(isequal(A,A'),'A is not symmetric');
M=A;
PP = eye(n);
for c = 1:(n-1)
    w = get_w(M(:,c),c);
    P = eye(n) - 2 * w * w';
    M = P*M*P;
    PP = PP * P;
    allA(:,:,c)=M;
    allP(:,:,c)=P;
end%for

end%func householder

% references for formula
%    https://en.wikipedia.org/wiki/Householder_transformation#Tridiagonalization
% or Numerical Analysis, Burden and Faires, 8th Edition
function v = get_w(a,k)
    alpha = -sign(a(k+1))*sqrt(sum(a(k+1:end).^2));
    r = sqrt(0.5*(alpha^2 - a(k+1)*alpha)  );
    v = zeros(length(a),1);
    v(k+1) = (a(k+1)-alpha)/(2*r);
    if (length(v)>(k+1))
        v(k+2:end) = a(k+2:end)/(2*r);
    end
end%func get_w

% this naive form does not work (some books have it)
function w = get_w_naive(a,aux)
    e = zeros(size(a));
    e(1) = 1;
    %w = (a - (-sign(a(1)))*norm(a)*e);
    w = (a - norm(a)*e);
    w = w / norm(w); 
    
end%func get_w

