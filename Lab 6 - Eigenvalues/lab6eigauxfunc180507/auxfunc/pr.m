%just to print with $g to check magnitude.
function pr(A,str,zerothreshold)
if (nargin < 2)
    str = [];
end
if (nargin < 3)
    zerothreshold = -1;
    zeromsg = [];
end
if (zerothreshold > 0)
    % zerothreshold signal does not matter
    zerothreshold = abs(zerothreshold);
    % zeroes all elements of A below zerothreshold in module.
   A(abs(A)<abs(zerothreshold))=0; 
   zeromsg = [ ' (abs > ' sprintf('%.1g',zerothreshold) ' ) '];
end
if (~isempty(str))
    disp(str);
end
disp([ inputname(1) zeromsg ' = ' ])
disp(sprintf([ repmat('%9.3g\t', 1, size(A, 2)) '\n'], A'))
end
