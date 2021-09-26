% asserts that two variables have the same size
% only works with one or two dimensions
function assertAbsDiff(testCase,a,b,tolerance,msg)
abserr = max(max(abs(a-b)));
msg = [ msg char(10) 'absolute error is too big: ' num2str(abserr) char(10) ];
msg = [ msg inputname(2) '= ' mat2str(a) char(10) ];
msg = [ msg inputname(3) '= ' mat2str(b) char(10) ];
assertLessThanOrEqual(testCase, abserr, tolerance, msg);
end%func