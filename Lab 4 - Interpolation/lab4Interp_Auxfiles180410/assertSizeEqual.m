% asserts that two variables have the same size
% only works with one or two dimensions
function assertSizeEqual(testCase,a,b)

[la,ca] = size(a);
[lb,cb] = size(b);

msg = sprintf('variable %s has %d lines; variable %s has %d lines',inputname(2),la,inputname(3),lb);
msg = [msg char(10) 'They must have the same number of lines!'];
assertEqual(testCase,la,lb,msg);
msg = sprintf('variable %s has %d collumns; variable %s has %d collumns',inputname(2),ca,inputname(3),cb);
msg = [msg char(10) 'They must have the same number of collumns!'];
assertEqual(testCase,ca,cb,msg);


end%func