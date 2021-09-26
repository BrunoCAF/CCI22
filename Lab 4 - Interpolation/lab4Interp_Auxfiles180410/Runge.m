% function [t,h1,h2] = Runge(finterp,f,ab,cheby) 
% plot and tables an analyse of the Runge Fenomenon for a given
% interpolation function finterp
% finterp is a function pointer which must have the header:
% yq = finterp( x, y, xq);
%
% example
% Runge(@InterpolacaoNewtonCompleta)
% an empty argument [] skips the argument and assumes default values
%
% Runge(@InterpolacaoNewtonCompleta,[],[],1) 
% uses chebyshev nodes but the other arguments are % default
%
% example with interp1 (note, there are 3 arguments in interp, only the string is fixed here)
% Runge(@(xq,yq,xx) interp1(xq,yq,xx,'linear'))
%
% similar with csape
% Runge(@(x,y,xq) InterpolacaocsapeCompleta(x,y,xq,'periodic'),[],[],0)
%
%
% f : optional argument, function pointer, the function to be analysed
%     if not given or empty, it uses the Runge function
%
% ab: optional argument in the form of an interval [ begin end ]
%     if not given or empty, uses [-1 1]
%
% cheby: if > 0, uses chebyshev nodes. default: uses equally spaced nodes
%
function [t,h1,h2] = Runge(finterp,f,ab,cheby) 
estilos = {'b', 'g', 'r', 'c', 'm', 'y'};

if (nargin < 4) || isempty(cheby)
    cheby=-1;% default, use equally spaced nodes.
end
if (cheby > 0)
   nodename = ' nodes cheby ';
else
   nodename = ' nodes equal ';
end


if (nargin < 2) || isempty(f)
   f = @(x) (1 ./ (1 + 25 * x.^2)); %default is Runge function
end
rungefuncname = func2str(f);
rungefuncname = rungefuncname(5:end); % cut @(x) from string

if (nargin < 3) || isempty(ab)
    % a e b são extremos do intervalo
    a = -1; b = 1;
else
    a = ab(1); b = ab(end);
end

fnames = func2str(finterp);

% dt é o passo usado para o plot
dt = 0.001;
xq = (a:dt:b)';
yq = f(xq);

% Plota o gráfico de f(x)
h1 = figure; grid on; hold on;
plot(xq, yq, 'k-.','LineWidth',3);
xlabel('x');
ylabel(['f(x) = ' rungefuncname  ]);
title(['Runge: ' fnames ' : ' nodename]);
legs{1} = ['f(x) = ' rungefuncname];

% Vamos usar N=2^1,2^2,2^3,2^4
for i=1:4
    n = 2^i;  
    if (cheby>0)
        x = chebyshev_nodes(a,b,n+1);
    else
        % Igualmente espaçado com n divisões (e n+1 pontos)
        h = (b - a) / n;
        x = (a:h:b)';
    end
    y = f(x);
    yq = finterp( x, y, xq);
    plot(xq, yq, [estilos{i} '-'],'LineWidth',2);
    legs{end+1} = sprintf('p_{%d}(x)', n);
    
end
legend(legs);

print -dpng -r300 CheChG.png;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

maxN = 50;
Npts = (2:maxN);
eMax = [];
eInt = [];
% Calcula max|f(x) - p_N(x)|, com x no intervalo [-1,1]
for N = Npts
    if (cheby>0)
        x = chebyshev_nodes(a,b,N+1);
    else
        % Igualmente espaçado com n divisões (e n+1 pontos)
        h = (b - a) / N;
        x = (a:h:b)';
    end
    y = f(x);
    yq = finterp( x, y, xq);
    eMax(end+1) = max(abs(f(xq) - yq));

    fi = @(xx) interp1(xq,yq,xx,'nearest'); % uses only the interpolated points
    ferri = @(xx) abs(fi(xx) - f(xx)); % absolute error
    eInt(end+1) = integral(ferri,a,b); % numerical integration of error

end
% Encontra o mínimo dos eMax's
[minEMax, indexMinEMax] = min(eMax);
[minEInt, indexMinEInt] = min(eInt);

h2 = figure; hold on;
% Plota gráfico de como varia E(n) com n
plot(Npts, eMax,'b-+','LineWidth',2);
plot(Npts, eInt,'r-+','LineWidth',2);
plot(Npts(indexMinEMax), minEMax, 'b*','LineWidth',3);
plot(Npts(indexMinEInt), minEInt, 'rs','LineWidth',3);
legend('max(|f(x)-p_n(x)|)','integral(|f(x)-p_n(x)|)','min','min');
xlabel(['n pontos de interpolacao para ' fnames]);
title(sprintf('max(|f(x) - p_n(x)|) no intervalo [%g,%g]', a,b));
grid on;

print -dpng -r300 CheChGE.png;

%%% TABLE

Npts = Npts'; % need collumn vector
eMax = eMax';
eInt = eInt';
disp(['min erorrs for ' fnames])
t = table(Npts,eMax,eInt)

end % functon