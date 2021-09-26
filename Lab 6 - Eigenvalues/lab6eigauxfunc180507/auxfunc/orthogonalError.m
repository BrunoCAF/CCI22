% if not zero, then M is not orthogonal
% try  to prove that M is not orthogonal
% return the maximum residue which shows how much non-orthogonal it is
function maxerr = orthogonalError(M,do_verbose)

if nargin < 2
    do_verbose=false;
end

n = length(M);

error_MtimesMT = max(max(abs(M*M'- eye(n))));
error_MTminusInvM = max(max(abs(M'-inv(M))));

if (do_verbose)
    disp([ 'check if ' inputname(1) ' is orthogonal:' ])
    table(error_MtimesMT,error_MTminusInvM)
end%if

maxerr = max(error_MtimesMT,error_MTminusInvM);
