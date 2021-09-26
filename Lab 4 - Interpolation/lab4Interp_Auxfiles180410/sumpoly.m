% calculates the sum of 2 polynomials
% p1,p2, and return ps are polynomials in polyval() vector form
function ps = sumpoly(p1,p2)
    ml = max(length(p1),length(p2));
    p1 = [ zeros(1,ml - length(p1)) p1 ]; % fill vectors with zeros
    p2 = [ zeros(1,ml - length(p2)) p2 ];
    ps = p1+p2;
end