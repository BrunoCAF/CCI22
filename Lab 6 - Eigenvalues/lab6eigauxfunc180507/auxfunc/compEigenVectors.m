% given two matrices which represent eigenvectors in their collumns
% compare them and return the maximum error among all elements
%
% it sorts the collumns
% it changes signals such that first line is positive
% therefore it may compare results of different algorithms which return
% eigenvalues in different order or different signals
function [max_error] = compEigenVectors(V,R)
%must be the same size
assert(isequal(size(V),size(R)),'inputs must have the same size')

% eigenvectors may have inverse directions.
 for c=1:length(V)
    if (V(1,c)<0) % all collumns have 1st element positive
        V(:,c) = -V(:,c);
    end
    if (R(1,c)<0)
        R(:,c) = -R(:,c);
    end
 end
% eigenvectors may be in different order, sort collumns
 V = sortrows(V')';
 R = sortrows(R')';

max_error = max(max(abs(R - V)));