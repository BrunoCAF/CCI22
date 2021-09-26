function [t,residue, fnames]=compLinSysTimes(ntests,n,f,genf)


for i = 1:ntests

   A{i} = genf(n);

   disp('-');

   b{i} = (rand(n,1));

end


for i=1:length(f)

    fc = f{i};

    fnames{i,1} = func2str(fc);

end


residue = zeros(length(f),1);

t = zeros(length(f),1);

niter = zeros(length(f),1);


for i = 1:ntests

    for fidx = 1:length(f)

        fc = f{fidx};

        tic

        [x,dr] = fc(A{i},b{i});

        t(fidx) = t(fidx)+toc;

        % for the non-iterative methods, dr and niter have no meaning.

        niter(fidx) = niter(fidx) + length(dr);

        residue(fidx) = residue(fidx) + max(A{i} * x - b{i});

        disp('.');

    end

    disp('*');

end



residue = residue / ntests;

disp(sprintf('\n************\n compLinSys: %d tests, %d size, %s generative function',ntests,n,func2str(genf)))

disp('NOTE1: t is in ms. niter = number of iterations')

disp('NOTE2: for the direct (non-iterative) methods, niter has no meaning.')

t = (t / ntests)*1e3;
% in ms
niter = niter / ntests;


table(fnames,residue,t,niter)


