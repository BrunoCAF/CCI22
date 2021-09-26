function T = TabelaDiferencasDivididas(x, y)
% T = TabelaDiferencasDivididas(x, y) calcula a Tabela de Diferenças 
% Divididas T a partir de n + 1 pontos de interpolação, definidos pelos 
% vetores coluna x = [x_0,x_1,...,x_n]' e y = [f(x_0),f(x_1),...,f(x_n)]'. 
% Adota-se o seguinte formato para T:
% T =
% [ f[x_0]   f[x_0,x_1]   f[x_0,x_1,x_2]   ...   f[x_0,x_1,...,x_n] ]
% [ f[x_1]   f[x_1,x_2]   f[x_1,x_2,x_3]   ...   0                  ]
% [ f[x_2]   f[x_2,x_3]   f[x_2,x_3,x_4]   ...   0                  ]
% [ ...      ...          ...              ...   ...                ]
% [ f[x_n]   0            0                ...   0                  ]
% Note ainda que T tem dimensão (n+1)x(n+1).

n = length(x) - 1;

T = zeros(n+1);

% Montar Tabela de Diferenças Divididas
T(:,1) = y;
for k = 2:n+1
    T(1:end+1-k,k) = (T(2:end+2-k,k-1) - T(1:end+1-k,k-1))./(x(k:end) - x(1:end+1-k));
end

end
