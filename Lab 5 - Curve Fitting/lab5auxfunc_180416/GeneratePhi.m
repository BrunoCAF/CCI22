function Phi = GeneratePhi()

Phi{1} = @(x) ones(size(x));
Phi{2} = @(x) x;
Phi{3} = @(x) x.^2;

end