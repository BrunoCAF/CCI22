clear all;
% try with 3 beacons and 4 beacons. (!!!!!!!TRY THIS!!!!!!!!)
% with 4 it is more likely to be close to true position!
% then try with more beacons, up to 1 million of beacons. (!!!!!!!TRY THIS!!!!!!!!)
% it should be easier and more precise with more beacons (but do not expect magic)
n_beacons = 4;%1e6;

range_error = .5;

% random geometry, probably it is good, low DOP
beacons = 10 * rand(n_beacons,2); % random, probably good
% try this to get big DOP, big error, due to bad geometry (!!!!!!!TRY THIS!!!!!!!!)
% it may diverge!!!
%beacons = 8 + 2 * rand(n_beacons,2); % too close to each other, bad geometry

truepose = 10 * rand(2,1);

trueranges = ((beacons(:,1)-truepose(1)).^2 + (beacons(:,2)-truepose(2)).^2).^0.5 ;
%ranges = trueranges + range_error * (rand(size(trueranges))-0.5); % uniform error
ranges = trueranges + range_error * randn(size(trueranges)); % normal error

[pos,poslcov,posinv,ts,DOP] = trilateration(beacons,ranges);
finalerror = norm(pos-truepose);

if (n_beacons < 20) % do not draw if there are too many points
 figure; hold on; grid on;
 ms = 10;
 plot(beacons(:,1),beacons(:,2),'ob','MarkerSize',ms);
 plot(truepose(1),truepose(2),'*r','MarkerSize',ms+2);
 plot(pos(1),pos(2),'xg','MarkerSize',ms);
 plot(poslcov(1),poslcov(2),'^m','MarkerSize',ms);
 plot(posinv(1),posinv(2),'vk','MarkerSize',ms);
 legend({'beacons','true position','MinSq result','lscov result','x=(A^T*A)^{-1}*A^T*b'});
end
if (n_beacons < 5) 
    for b = 1:n_beacons
        quad2dplot(circle2quad(beacons(b,:),trueranges(b)),'g',1);
        quad2dplot(circle2quad(beacons(b,:),ranges(b)),'r',1);
    end
    addlegend('true ranges');
    addlegend('measured ranges');
end
title(sprintf('final error= %.3e   DOP= %.2e',finalerror,DOP))

disp(sprintf('DOP = %.2e',DOP))
disp('final error');
disp(sprintf('myls  %f',finalerror));
disp(sprintf('lscov %f',norm(poslcov-truepose)));
disp(sprintf('lsivv %f',norm(posinv-truepose)));
disp('times');
disp(sprintf('myls  %f',ts.ttril ));
disp(sprintf('lscov %f',ts.tlscov ));
disp(sprintf('lsivv %f',ts.tinv ));
