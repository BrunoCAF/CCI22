function yq = InterpolacaoSplineCubica(x, y, xq)

% yq = InterpolacaoSplineCubica(x, y, xq) realiza interpolacao usando o 

% metodo Spline Cubica. Os vetores coluna x = [x0,x1,...,xn]^T e 

% y = [y0,y1,...,yn]^T são os n + 1 nós de interpolacao. O vetor coluna 

% xq contem os valores para os quais se deseja calcular a interpolacao. 

% A saida da funcao eh o vetor coluna yq tal que yq(j) = p(xq(j)), em que 

% p eh a funcao gerada pelas funcoes splines construidas para cada segmento

% a partir dos n + 1 nos de interpolacao.


n = length(x) - 1;

m = length(xq);


yq = zeros(size(xq));


%s = zeros(n, 4);

[a, b, c, d] = SistemaSplineCubica(x, y);

f = SolucaoTridiagonal(a, b, c, d);

F = [0; f; 0];

h = diff(x);


%s(i) = 

% ( F(i) /6*h(i))*(conv([-1 x(i+1)], conv([-1 x(i+1)], [-1 x(i+1)]))) + 

% (F(i+1)/6*h(i))*(conv( [1 -x(i)] , conv( [1 -x(i)] ,  [1 -x(i)] ))) + 

% (y(i+1)/h(i) - h(i)F(i+1)/6)*( [0 0 1 -x(i)] ) + 

% ( y(i) /h(i) - h(i) F(i) /6)*([0 0 -1 x(i+1)])


%si = 

% ( F(i) /6*h(i))*(x(i+1) - x)³ + 

% (F(i+1)/6*h(i))*(x - x(i))³ + 

% (y(i+1)/h(i) - h(i)F(i+1)/6)*(x - x(i)) + 

% ( y(i) /h(i) - h(i) F(i) /6)*(x(i+1) - x)


%Como saber qual s(i) usar?

%Se x(i) < xq < x(i+1), usar s(i)

%i = sum(xq(k) > x)

%s(i)

%yq = polyval(s(i), xq)


%I = sum((xq' > x'), 2);

%I = I + (I < 1);

%I = I - (I > n);


%for i = 1:m

%    s(I(i),:) = (F(I(i))/(6*h(I(i))))*(conv([-1 x(I(i)+1)], conv([-1 x(I(i)+1)], [-1 x(I(i)+1)])));

%    s(I(i),:) = (F(I(i)+1)/(6*h(I(i))))*(conv([1 -x(I(i))], conv([1 -x(I(i))], [1 -x(I(i))]))) + s(I(i),:);

%    s(I(i),:) = (y(I(i)+1)/h(I(i)) - h(I(i))*F(I(i)+1)/6)*([0 0 1 -x(I(i))]) + s(I(i),:);

%    s(I(i),:) = (y(I(i))/h(I(i)) - h(I(i))*F(I(i))/6)*([0 0 -1 x(I(i)+1)]) + s(I(i),:);

%end


%for i = 1:m

%    if I(i) == 0

%        I(i) = 1;

%    elseif I(i) == n+1

%       I(i) = n;

%   end

%    yq(i) = polyval(s(I(i),:), xq(i));

%end


for k = 1:m

    i = sum(xq(k) > x);

    if i < 1

        i = 1;

    elseif i > n

        i = n;

    end

    si = F(i)*((x(i+1) - xq(k))^3)/(6*h(i));

    si = si + F(i+1)*((xq(k) - x(i))^3)/(6*h(i));

    si = si + (y(i+1)/h(i) - h(i)*F(i+1)/6)*(xq(k) - x(i));

    yq(k) = si + (y(i)/h(i) - h(i)*F(i)/6)*(x(i+1) - xq(k));

end


end