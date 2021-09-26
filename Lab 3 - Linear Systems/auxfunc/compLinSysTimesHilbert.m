function [tH,residueH, fnames]=compLinSysTimesHilbert(n,f)
ntests = length(n);
for i=1:ntests
    H{i} = hilb(n(i)); %Hilbert matrix 10 x 10
    bH{i} = rand(n(i),1);
end
disp('input generated');

for i=1:length(f)
    fc = f{i};
    fnames{i,1} = func2str(fc);
end


residueH = zeros(length(f),1);
tH = zeros(length(f),1);
niterH = zeros(length(f),1);
for fidx = 1:length(f)
    for i=1:ntests
        fc = f{fidx};
        tic
        [x,dr] = fc(H{i},bH{i});
        tH(fidx) = tH(fidx) + toc * 1e3;
        % for the non-iterative methods, dr and niter have no meaning.
        niterH(fidx) = niterH(fidx) + length(dr);
        residueH(fidx) = residueH(fidx) + max(H{i} * x - bH{i});
        disp('.');
    end%for
    disp('*');
end%for

residueH = residueH / ntests;
niterH = niterH / ntests;
tH = tH / ntests;
disp(sprintf('\n************\n compLinSys HILBERT: %s sizes ',mat2str(n)))
disp('NOTE1: t is in ms. niter = number of iterations')
disp('NOTE2: for the direct (non-iterative) methods, niter has no meaning.')

table(fnames,residueH,tH,niterH)


