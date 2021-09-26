clear all; close all;
%% DATA USED IN VARIOUS PROBLEMS
% f2 
f2 = @(x) 0.5 + 0.04*x.^2 + 2*exp(-((-0.5+x/2)).^2).*sin(4*pi*x).*cos(3*pi*x);
% f1 
f1 = @(x) 0.5 + 0.02*x.^2 + exp(-(x-1).^2).*sin(pi*x);

epsilon = 1e-4; % with smaller epsilon, more points are needed
%epsilon = 1e-8; % with smaller epsilon, more points are needed

%% LIST OF PROBLEMS
% usual example, it works! TRY WITH epsilon=1e-8 and epsilon=1e-4
p1.f = f1; p1.a = -5; p1.b = 5; p1.inttrue = 6.66666667115867970983; % true value from wolfram

% first wicked example: TRY WITH epsilon=1e-8
%https://www.wolframalpha.com/input/?i=Integral+of+%280.5%2B0.02*x^2+%2B+e^%28-%28x-1%29^2%29*sin%28pi*x%29+++%29+from+-5+to+7
p2.f = f1; p2.a = -5; p2.b = 7; p2.inttrue = 9.12; % value from wolfram for -5 to 7

% tooootally wicked example. 
% before running it, how many points do you think it would be needed?
% a simple way to plot the function: ezplot(f2)
% https://www.wolframalpha.com/input/?i=Integral+of+0.5+%2B+0.04*x^2+%2B+2*exp%28-%28%28-0.5%2Bx%2F2%29%29^2%29*sin%284*pi*x%29*cos%283*pi*x%29+from+-5+to+7
p3.f = f2; p3.a = -5; p3.b = 7; p3.inttrue = 12.24; %f2, -5 a 7

% just to prove its no coincidence, f2 is really cursed by black magic: change the interval
% inttrue=0: I did not care to get true values, so 'error' is  = answer - 0 = answer
p4.f = f2; p4.a = -5; p4.b = 5; p4.inttrue = 0; %f2, -5 a 5

% now, try this interval, lest someone really start believing in witches
p5.f = f2; p5.a = -5; p5.b = 5.5; p5.inttrue = 0; %f2, -5 a 5.5
% why is it so different?
% why the suprising behavior?

% another reality check: open compareInt, and change quad to the version with trapezio
% it already has a commented line to do that.
% trapezio must work, but it does not have O(h^4) error black magic

% try other functions!

%% SOLVE 
%%% ************* change p = p1 to p = pX to run other problems ******
p = p4; %% CHANGE HERE TO RUN OTHER PROBLEMS
%%% *************************************************

compareInt(p.f,p.a,p.b,epsilon,p.inttrue,0); % last parameter: 1 plot vertical lines, 0 does not plot



