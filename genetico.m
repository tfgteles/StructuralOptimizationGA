% Algoritmo Genético

% Tiago Franco de Goes Teles, 2010

% -----------------
% PARÂMETROS INICIAIS
% -----------------

clear all
nvar=10; % número de variáveis do problema
nind=60; % número de indivíduos de uma população
nsol=1; % número de soluções para apresentar resultado e variáveis
tpsel=2; % método de seleção, 1 para "Stochastic Universal Sampling (SUS)",
% 2 para método da roleta.
tc=0.7; % taxa de cruzamento
tm=0.05; % taxa de mutação
gmax=50; % número máximo de gerações
gmin=1; % número mínimo de gerações
tol=1; % máxima diferença entre o melhor indivíduo e a média dos 80%
% melhores indiv. de uma geração para verificar a convergência do problema,
% estes volores foram deslocados para valores positivos e normalizados
% Dimensão dos vetores que armazenam as variáveis, ou seja,
% a quantidade de valores discretos de cada variável - dimvar
dimvar(1:10)=42;
% Espaço de busca da primeira variável - var01
var(1,:)=1:42;
% Espaço de busca da segunda variável - var02
var(2,1:dimvar(2))=var(1,:);
for i=3:10
    var(i,:)=var(1,:);
end


% -----------------
% PROCESSAMENTO
% -----------------

% Determinação da população inicial
P=zeros(nind,nvar); P=popini(dimvar,nind);

% Determinação do valor da função objetivo para cada indivíduo da
% população inicial - popadap
popadap(:,1)=fobjetivo(P,var);

% Aplicação dos operadores genéticos até atingir a convergência
for i=2:gmax
    % Aplicação do operador seleção
    [P,sel,ne]=selecao(P,popadap(:,i-1),tc,tpsel);
    % Aplicação do operador cruzamento
    P=cruzamento(P,sel);
    % Aplicação do operador mutação
    P=mutacao(P,tm,dimvar,ne);
    % Teste de convergência - conv (1 se convergiu, 0 caso contrário)
    popadap(:,i)=fobjetivo(P,var);
    c=convergencia(popadap(:,i),tol);
    if i>=gmin; if c==1; break; end; end
end
it=i;

% -----------------
% RESULTADO
% -----------------

if c==0
    disp('O programa não convergiu')
    it
    [Sol,adap]=resultado(P,popadap(:,it),var,nsol)
else
    disp('o programa convergiu')
    it
    [Sol,adap]=resultado(P,popadap(:,it),var,nsol)
end

[peso,tsmax,tsmin,deslmax,deslmin]=trelica2d(Sol(1,:));