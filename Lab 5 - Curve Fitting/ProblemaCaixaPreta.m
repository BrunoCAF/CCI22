[X1, X2] = meshgrid(10:10:100, 10:10:100);
m = size(X1, 1) * size(X1, 2);
x1 = reshape(X1, m, 1);
x2 = reshape(X2, m, 1);

T = MedirTempoFuncaoCaixaPreta(x1, x2);

%fT(n1, n2) = gamma * n1^alpha * n2^beta <=>
%log(T) = log(gamma) + alpha*log(n1) + beta*log(n2)
c = RegressaoLinear2D(log(x1), log(x2), log(T));
gamma = exp(c(1)); alpha = c(2); beta = c(3);
% gamma = 6.019272654778828*1e-9
% alpha = 1.981941173254849
% beta  = 0.943742700698183

fT = @(x, y)(gamma*(x.^alpha).*(y.^beta)); 
Z = fT(10:10:100, (10:10:100)');

surf(10:10:100, 10:10:100, Z);
hold on;
plot3(x1, x2, T, 'm*');
xlabel('n1'); ylabel('n2'); zlabel('Tempo de Execução');
legend('Superfície Ajustada', 'Pontos Experimentais', 'location', 'Northwest');
title('Tempo de execução x tamanho das entradas');
grid on; grid minor;
axis fill;

print -dpng -r400 caixapreta.png