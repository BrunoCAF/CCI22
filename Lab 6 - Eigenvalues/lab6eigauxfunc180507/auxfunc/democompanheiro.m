clear all; close all;
n = 4;

%% try the 3 options to generate roots

%theroots = sort(rand(1,n)); % real roots

%https://en.wikipedia.org/wiki/Complex_conjugate_root_theorem
% for p poly with real coeficients, if complex c is root of p, then
% conjugate of c is also root of p. i.e., complex roots come in pairs.
theroots = sort([rand(1,n-2)  rand(1) * [1 1] + rand(1)*[i -i]]); % 2 conjugate complex roots at the end

% another interesting test: 
% create impossible roots, like only one complex root
%theroots = sort(rand(1,n))+[ i zeros(1,n-1) ];
% this demonstrate a famous computational principle: garbage in, garbage out.

%% 

p = poly(theroots);
C = compan(p);

eigC = sort(eig(C)');

[D,QQ,niter]=geigenqr(C,1e3);
eigQRC = sort(diag(D)');

eigQRC
eigC
theroots
doublecheck = sort(roots(p)')
p


 