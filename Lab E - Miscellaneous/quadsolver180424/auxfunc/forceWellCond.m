
function A = forceWellCond(A)
    n = length(A);
    if (n > 10) % for large matrices force it to be well conditioned
        MaxN = 50; 
        S=diag(round(MaxN * rand(1,n)));
        U = orth(round(MaxN * rand(n))); % avoid small elements, and orth is well cond
        A= U*S*U'; % a very fake inverse svd, at least it is diagonal dominant
        A = 0.5*A*A'; % force simmetric
    else
        %do nothing, let A continue the same
    end
end%func