

function compareInt(f,a,b,epsilon,inttrue,doplotlines)


if nargin < 6
   doplotlines = 1; 
end

%% Quadratura Adaptiva
tic
[Iq, x] = gIntegracaoQuadraturaAdaptativa(f, a, b, epsilon);
%[Iq, x] = gIntegracaoQuadraturaAdaptativaTrapezio(f, a, b, epsilon);
tQ = toc;
errQuad = abs(Iq - inttrue);

% get the choosen points for QuadAdapt and its values in f.
npt = length(x);
h = (b-a)/(npt-1);
eqx = linspace(a,b,npt);
y = f(eqx);


%% matlab simpson adaptive
tic
[Imq, n_eval_mlab] = quad(f,a,b,epsilon);
tMl=toc;
errMq = abs(Imq - inttrue);

%% simpson 
tic
Isimp = gIntegracaoSimpson(h, y);
tS = toc;
errSimp = abs(Isimp - inttrue);

%% trap 
tic
Itrap = gIntegracaoTrapezio(h, y);
tT = toc;
errTrap = abs(Itrap - inttrue);


table(npt,errQuad,errSimp,errMq,errTrap,n_eval_mlab,tQ,tS,tMl,tT)

%% plots

xx = linspace(a,b,500); % points to plot
yy = f(xx);
df = diff(yy)/(xx(2)-xx(1)); % approximate derivative
df = [df(1) df]; % repeat value, just to make vectors the same size
% scale the derivative, just to draw it in the plot
dfscale = 0.5 * max(yy)/max(df);
df = df * dfscale ; % scale just to make it fit in the plot

df_at_x = interp1(xx,df,x); % interpolate to get df at the chosen points

diff_pt = diff(x); % diference between consecutive choosen points in x axis.
diff_pt = [diff_pt(1) diff_pt];% repeat value, to make vectors the same size

figure; hold on; grid on; lw=4;
plot(xx,yy,'-','LineWidth',lw);
plot(xx,df,'-r','LineWidth',lw-1);
plot(x,diff_pt,'-m','LineWidth',lw);
plot(x,f(x),'g*','MarkerSize',15,'LineWidth',lw);
choosenlegend = [sprintf('%d choosen points',npt)];
if doplotlines > 0
    for i=1:length(x)
        line([x(i) x(i)],[-0.5 1.5]);
    end
    choosenlegend = [ choosenlegend ' with vertical lines'];
end
title('adaptive quadrature integration');
dflegend = [ '$\frac{df}{dx} \cdot ' sprintf('%.2f',dfscale) '$' ];
flegend = func2str(f);
flegend = [ 'f(x)= ' flegend(5:end)]; % cut @(x) from string
legend({flegend,dflegend,'interval in x between choosen pts',choosenlegend},'FontSize',18,'interpreter','latex');



end%func