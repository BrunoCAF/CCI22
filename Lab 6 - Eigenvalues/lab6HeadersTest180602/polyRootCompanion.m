function proots = polyRootCompanion(p)

proots = sort(diag(eigenqr(compan(p))))';

end