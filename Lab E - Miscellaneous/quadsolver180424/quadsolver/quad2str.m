% given a quadric, writes a string to print it out
function qs = quad2str(q)
%Ax^2 + Bxy + Cy^2 + Dx + Ey + F = 0
qs = '';
if (q(1)~=0)
    qs = [ qs sprintf('%+.3gx^2 ',q(1) )]; 
end
if (q(2)~=0)
    qs = [ qs sprintf('%+.3gxy ',q(2) )]; 
end
if (q(3)~=0)
    qs = [ qs sprintf('%+.3gy^2 ',q(3) )]; 
end
if (q(4)~=0)
    qs = [ qs sprintf('%+.3gx ',q(4) )]; 
end
if (q(5)~=0)
    qs = [ qs sprintf('%+.3gy ',q(5) )]; 
end
if (q(5)~=0)
    qs = [ qs sprintf('%+.3g ',q(6) )]; 
end



end%func