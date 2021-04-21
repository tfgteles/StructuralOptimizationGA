% Algoritmo Gen�tico

% Tiago Franco de Goes Teles, 2010

% -----------------
% PAR�METROS INICIAIS
% -----------------

clear all
nvar=10; % n�mero de vari�veis do problema
nind=60; % n�mero de indiv�duos de uma popula��o
nsol=1; % n�mero de solu��es para apresentar resultado e vari�veis
tpsel=2; % m�todo de sele��o, 1 para "Stochastic Universal Sampling (SUS)",
% 2 para m�todo da roleta.
tc=0.7; % taxa de cruzamento
tm=0.05; % taxa de muta��o
gmax=50; % n�mero m�ximo de gera��es
gmin=1; % n�mero m�nimo de gera��es
tol=1; % m�xima diferen�a entre o melhor indiv�duo e a m�dia dos 80%
% melhores indiv. de uma gera��o para verificar a converg�ncia do problema,
% estes volores foram deslocados para valores positivos e normalizados
% Dimens�o dos vetores que armazenam as vari�veis, ou seja,
% a quantidade de valores discretos de cada vari�vel - dimvar
dimvar(1:10)=42;
% Espa�o de busca da primeira vari�vel - var01
var(1,:)=1:42;
% Espa�o de busca da segunda vari�vel - var02
var(2,1:dimvar(2))=var(1,:);
for i=3:10
    var(i,:)=var(1,:);
end


% -----------------
% PROCESSAMENTO
% -----------------

% Determina��o da popula��o inicial
P=zeros(nind,nvar); P=popini(dimvar,nind);

% Determina��o do valor da fun��o objetivo para cada indiv�duo da
% popula��o inicial - popadap
popadap(:,1)=fobjetivo(P,var);

% Aplica��o dos operadores gen�ticos at� atingir a converg�ncia
for i=2:gmax
    % Aplica��o do operador sele��o
    [P,sel,ne]=selecao(P,popadap(:,i-1),tc,tpsel);
    % Aplica��o do operador cruzamento
    P=cruzamento(P,sel);
    % Aplica��o do operador muta��o
    P=mutacao(P,tm,dimvar,ne);
    % Teste de converg�ncia - conv (1 se convergiu, 0 caso contr�rio)
    popadap(:,i)=fobjetivo(P,var);
    c=convergencia(popadap(:,i),tol);
    if i>=gmin; if c==1; break; end; end
end
it=i;

% -----------------
% RESULTADO
% -----------------

if c==0
    disp('O programa n�o convergiu')
    it
    [Sol,adap]=resultado(P,popadap(:,it),var,nsol)
else
    disp('o programa convergiu')
    it
    [Sol,adap]=resultado(P,popadap(:,it),var,nsol)
end

[peso,tsmax,tsmin,deslmax,deslmin]=trelica2d(Sol(1,:));