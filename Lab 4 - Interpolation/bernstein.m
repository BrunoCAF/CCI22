function [P, B] = bernstein(n)

B = cell(n+1, n+1);

B{1,1} = ones(1,1);

for m = 2:n+1
    B{m, 1} = conv([-1 1], B{m-1, 1});
    for j = 2:m-1
        B{m, j} = conv([-1 1], B{m-1, j}) + conv([1 0], B{m-1, j-1});
    end
    B{m, m} = conv([1 0], B{m-1, m-1});
end

P = cell(size(1, n+1));
for m = 1:n+1
    P{1, m} = B{n+1, 1};
end

end