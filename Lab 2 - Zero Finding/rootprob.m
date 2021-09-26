%% using fzero with complete output information, plot, and tolerance parameter
% example 
% rootprob(@cos, 1 , 1e-6)
% f function handle
% x0 intial guess (or interval if it is a size 2 vector)
% tol tolerance on x
%%
function [x fval exitflag output] = rootprob( f, x0, tol )
problem.objective = f;
problem.x0 = x0;
problem.solver = 'fzero'; % a required part of the structure
problem.options = optimset('fzero');
problem.options = optimset(problem.options,'Display','iter','PlotFcns',{@optimplotx,@optimplotfval},'TolX',tol); % default options
[x fval exitflag output] = fzero(problem)