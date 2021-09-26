function ord = bubblesort(x)

for p = max(size(x)):-1:1
    trocou = false;
    for i = 1:p-1
        if x(i) > x(i+1)
            u = x(i);
            x(i) = x(i+1);
            x(i+1) = u;
            trocou = true;
        end
    end
    if trocou == false
        break;
    end
end

ord = x;

end