ep = single(1.0);

while (single(1.0) + ep/single(2.0) > single(1.0))
    ep = ep/single(2.0);
end

disp(sprintf("Single: %.50g", ep))

dep = double(1.0);

while (double(1.0) + dep/double(2.0) > double(1.0))
    dep = dep/double(2.0);
end

disp(sprintf("Double: %.50g", dep))