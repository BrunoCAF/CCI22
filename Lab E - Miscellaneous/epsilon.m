function epsilon = epsx(x)

epsilon = (2.0).^double(int64( log2( abs(x) ) ));

while max(max(x + epsilon/2 > x))
    L = (x + epsilon/2 > x) + 1;
    epsilon = epsilon./L;
end