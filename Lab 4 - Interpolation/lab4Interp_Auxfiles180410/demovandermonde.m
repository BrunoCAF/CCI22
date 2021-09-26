
%% define interpolation nodes
% tente algumas vezes com:
% n <= 15
% n ~ 25
% n > 30
n = 25; 
x = 2*rand(n,1)-1;% cheby only works in [-1 1] interval
y = 2*rand(n,1)-1;
x = sort(x);

%% call interpolation functions, get polynomials
[pc,cc] = gChebyPolyInterp(x, y);
[pi,ci] = gPolinomioInterpolador(x, y);

%% points to plot the polynomials
xx = [ -1.1:0.005:1.1 x' ]; % include the nodes on the plot
xx = sort(xx);
ypc = polyval(pc,xx);
ypi = polyval(pi,xx);

%% cute plots 
figure; hold on; grid on;
plot(xx,ypc,'g-','LineWidth',2);
plot(xx,ypi,'r--','LineWidth',2);
plot(x,y,'bo','MarkerSize',6);
legend({'chebyp interp','vandermonde interp','nodes'},'FontSize',16);
ylim([-10 10]);
f2=copyobj(gcf,0);
figure(f2);
ylim([-1 1]);
disp(sprintf('Cheby cond(A) = %.4g  ; canonic basis cond(A) = %.4g',cc,ci))
disp(sprintf('max diff Cheby - vandm %g',max(abs(ypc-ypi))  ))
%calculate residuals
ynodesc = polyval(pc,x); % calculate the polynomials at the nodes
ynodesi = polyval(pi,x);
disp(sprintf('Cheby: max residual: %10.6g RMS residual: %10.6g',max(abs(ynodesc-y)),rms(ynodesc-y) ));
disp(sprintf('Canon: max residual: %10.6g RMS residual: %10.6g',max(abs(ynodesi-y)),rms(ynodesi-y) ));


