% performs triangulation, i.e., calls the matlab least sq routine
% as done in Beutel and Savarese thesis

% input: 
% beacon: rows are the positions of the beacons [x,y]
% range: range measurements corresponding to the beacons

%output
%pos estimated position of the unknown node

function [pos,poslcov,posinv,ts,DOP] = trilateration(beacon,range)

[n aux] = size(beacon);

Aold = -2 * [ (beacon(1:n-1,1) - beacon(n,1)) (beacon(1:n-1,2) - beacon(n,2))];

% b is the initial right part of the system before least squares derivation
b = range(1:n-1).^2 - beacon(1:n-1,1).^2 -  beacon(1:n-1,2).^2;
b = b - range(n)^2 + beacon(n,1)^2 + beacon(n,2)^2;

% auxiliary matrices.
x = beacon(1:n-1,1) - beacon(n,1); %  beacon_x_i - beacon_x_n
y = beacon(1:n-1,2) - beacon(n,2); %  beacon_y_i - beacon_y_n

DOP = sqrt(sum(diag(inv(Aold'*Aold))).^2);

tic
[A,B] = gcalcAandBforTrilateration(x,y,b);
pos = A\B;
ts.ttril = toc;

tic
poslcov = lscov(Aold,b); % ready leastsquares from matlab
ts.tlscov = toc;

tic
posinv = inv(Aold' * Aold) * Aold' * b; % the other way
ts.tinv = toc;

