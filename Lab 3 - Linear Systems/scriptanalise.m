%Definindo os parametros
x0 = [0;0;0];
maxiter = 100;
epsilon = 0.001;

%Definindo os sistemas
A1 = [1 3 1; 5 2 2; 0 6 8];
b1 = [-2;3;-6];

A2 = [5 2 2; 1 3 1; 0 6 8];
b2 = [3;-2;-6];

A3 = [1 3 4; 1 -3 1; 1 1 5];
b3 = [8;-9;1];

A4 = [1 2 -2; 1 1 1; 2 2 1];
b4 = [3;0;1];

A5 = [2 1 1; 1 2 1; 1 1 2];
b5 = [4;4;4];

A6 = [5 -1 1;2 4 -1; -1 1 3]; 
b6 = [10;11;3];

%Inicializando os dados a serem coletados
Linhas = [false; false; false; false; false; false];
Sassenfeld = [false; false; false; false; false; false];
GJnumIter = [0;0;0;0;0;0];
GSnumIter = [0;0;0;0;0;0];
GJconv = [false; false; false; false; false; false];
GSconv = [false; false; false; false; false; false];


%Coletando os dados para o método de Gauss-Jacobi
Linhas(1) = CriterioLinhas(A1);
[xGJ1, drGJ1] = GaussJacobi(A1, b1, x0, epsilon, maxiter);
GJnumIter(1) = max(size(drGJ1));
GJconv(1) = (GJnumIter(1) < maxiter);

Linhas(2) = CriterioLinhas(A2);
[xGJ2, drGJ2] = GaussJacobi(A2, b2, x0, epsilon, maxiter);
GJnumIter(2) = max(size(drGJ2));
GJconv(2) = (GJnumIter(2) < maxiter);

Linhas(3) = CriterioLinhas(A3);
[xGJ3, drGJ3] = GaussJacobi(A3, b3, x0, epsilon, maxiter);
GJnumIter(3) = max(size(drGJ3));
GJconv(3) = (GJnumIter(3) < maxiter);

Linhas(4) = CriterioLinhas(A4);
[xGJ4, drGJ4] = GaussJacobi(A4, b4, x0, epsilon, maxiter);
GJnumIter(4) = max(size(drGJ4));
GJconv(4) = (GJnumIter(4) < maxiter);

Linhas(5) = CriterioLinhas(A5);
[xGJ5, drGJ5] = GaussJacobi(A5, b5, x0, epsilon, maxiter);
GJnumIter(5) = max(size(drGJ5));
GJconv(5) = (GJnumIter(5) < maxiter);

Linhas(6) = CriterioLinhas(A6);
[xGJ6, drGJ6] = GaussJacobi(A6, b6, x0, epsilon, maxiter);
GJnumIter(6) = max(size(drGJ6));
GJconv(6) = (GJnumIter(6) < maxiter);

%Coletando os dados para o método de Gauss-Seidel
Sassenfeld(1) = CriterioSassenfeld(A1);
[xGS1, drGS1] = GaussSeidel(A1, b1, x0, epsilon, maxiter);
GSnumIter(1) = max(size(drGS1));
GSconv(1) = (GSnumIter(1) < maxiter);

Sassenfeld(2) = CriterioSassenfeld(A2);
[xGS2, drGS2] = GaussSeidel(A2, b2, x0, epsilon, maxiter);
GSnumIter(2) = max(size(drGS2));
GSconv(2) = (GSnumIter(2) < maxiter);

Sassenfeld(3) = CriterioSassenfeld(A3);
[xGS3, drGS3] = GaussSeidel(A3, b3, x0, epsilon, maxiter);
GSnumIter(3) = max(size(drGS3));
GSconv(3) = (GSnumIter(3) < maxiter);

Sassenfeld(4) = CriterioSassenfeld(A4);
[xGS4, drGS4] = GaussSeidel(A4, b4, x0, epsilon, maxiter);
GSnumIter(4) = max(size(drGS4));
GSconv(4) = (GSnumIter(4) < maxiter);

Sassenfeld(5) = CriterioSassenfeld(A5);
[xGS5, drGS5] = GaussSeidel(A5, b5, x0, epsilon, maxiter);
GSnumIter(5) = max(size(drGS5));
GSconv(5) = (GSnumIter(5) < maxiter);

Sassenfeld(6) = CriterioSassenfeld(A6);
[xGS6, drGS6] = GaussSeidel(A6, b6, x0, epsilon, maxiter);
GSnumIter(6) = max(size(drGS6));
GSconv(6) = (GSnumIter(6) < maxiter);


%Plotando os vetores dr para o método de Gauss-Jacobi
drGJ1 = [drGJ1; zeros(maxiter - max(size(drGJ1)), 1)];
drGJ2 = [drGJ2; zeros(maxiter - max(size(drGJ2)), 1)];
drGJ3 = [drGJ3; zeros(maxiter - max(size(drGJ3)), 1)];
drGJ4 = [drGJ4; zeros(maxiter - max(size(drGJ4)), 1)];
drGJ5 = [drGJ5; zeros(maxiter - max(size(drGJ5)), 1)];
drGJ6 = [drGJ6; zeros(maxiter - max(size(drGJ6)), 1)];

figure;
hold on;
plot(1:maxiter, drGJ1, 'b');
plot(1:maxiter, drGJ2, 'g');
plot(1:maxiter, drGJ3, 'r');
plot(1:maxiter, drGJ4, 'y');
plot(1:maxiter, drGJ5, 'm');
plot(1:maxiter, drGJ6, 'k');
hold off;
legend({"Sistema 1", "Sistema 2", "Sistema 3", "Sistema 4", "Sistema 5", "Sistema 6"});
xlabel('Número da iteração');
ylabel('Resíduo do sistema');
title('Resíduos a cada iteração do Gauss-Jacobi');
grid on;

print -dpng -r400 residuosGJ.png;

%Plotando os vetores dr para o método de Gauss-Seidel
drGS1 = [drGS1; zeros(maxiter - max(size(drGS1)), 1)];
drGS2 = [drGS2; zeros(maxiter - max(size(drGS2)), 1)];
drGS3 = [drGS3; zeros(maxiter - max(size(drGS3)), 1)];
drGS4 = [drGS4; zeros(maxiter - max(size(drGS4)), 1)];
drGS5 = [drGS5; zeros(maxiter - max(size(drGS5)), 1)];
drGS6 = [drGS6; zeros(maxiter - max(size(drGS6)), 1)];

figure;
hold on;
plot(1:maxiter, drGS1, 'b');
plot(1:maxiter, drGS2, 'g');
plot(1:maxiter, drGS3, 'r');
plot(1:maxiter, drGS4, 'y');
plot(1:maxiter, drGS5, 'm');
plot(1:maxiter, drGS6, 'k');
hold off;
legend({"Sistema 1", "Sistema 2", "Sistema 3", "Sistema 4", "Sistema 5", "Sistema 6"});
xlabel('Número da iteração');
ylabel('Resíduo do sistema');
title('Resíduos a cada iteração do Gauss-Seidel');
grid on;

print -dpng -r400 residuosGS.png;
