function [peso,tsmax,tsmin,deslmax,deslmin]=trelica2d(x)

% Trelica 2D

% Tiago Franco de Goes Teles, 2010

% ------------------
%  DADOS DE ENTRADA
% ------------------

% Coordenadas dos nos - cno = [x1 y1; x2 y2; ...]
cno=[18000 9000; 18000 0; 9000 9000; 9000 0; 0 9000; 0 0]; % mm

% Incidencia nodal - indica os 2 nos de cada elemento
%                    id = [na1 nb1; na2 nb2; ...]
id=[5 3; 3 1; 6 4; 4 2; 4 3; 2 1; 5 4; 6 3; 3 2; 4 1];

% Modulo de elasticidade dos elementos - E = [E1 E2 ...]
E=68.9e3; % MPa

% Densidade dos elementos da estrutura
ro=2770; % kg/m3

% Opções de seção de perfil para ser atribuido a cada elemento - optA
optA(1:14)=[1045,1161,1284,1374,1535,1690,1697,1858,1890,1993,2019,2181,2239,2290];
optA(15:28)=[2342,2477,2497,2503,2697,2723,2897,2961,3097,3206,3303,3703,4658,5142];
optA(29:42)=[7419,8710,8968,9161,10000,10323,10903,12129,12839,14193,14774,17097,19355,21613];

% Deslocamentos prescritos - dp = [no dir valor; no dir valor; ...]
%                            para direcao x: dir=1
%                            para direcao y: dir=2
dp=[5 1 0; 5 2 0; 6 1 0; 6 2 0];

% Tracoes prescritas (carregamento nodal) - tp = [no dir valor; no dir valor]
tp=[4 2 -445e3; 2 2 -445e3];

% ----------------
%  PROCESSAMENTO
% ----------------

% Numero de nos - nno
[nno,i]=size(cno);

% Numero de elementos - nel
[nel,i]=size(id);

% Area da secao transversal de cada elemento - A = [A1 A2 ...]
% Escolha da seção de cada membro da treliça - x=[perfil_el01
% perfil_el02 ...]
for i=1:nel
    A(i)=optA(x(i));
end

% Comprimento dos elementos - L = [L1 L2 ...]
L=comprimento(cno,id,nel);

% Matriz de rigidez do sistema - K
K=rigidez(cno,id,E,A,L);

% Vetor de carregamento nodal - f
f=carregamento(tp,nno);

% Aplicacao dos deslocamentos prescritos - o sistema K.u=f sem os
% deslocamentos prescritos passa a ser Km.u=fm com estas condicoes
[Km,fm]=deslocamentos(K,f,dp);

% Solucao nodal em termos de deslocamentos - u
% u = [u1; v1; u2; v2; ...]
% u=decomplu(-Km,fm);
u=Km\fm;

% --------------------
%  POS-PROCESSAMENTO
% --------------------

% Deformacao em cada elemento - e = [e1 e2 ...]
e=deformacao(u,id,cno,E,A,L);

% Tensao em cada elemento - ts = [ts1 ts2 ...]
ts=e*E;

% Peso total da estrutura
peso=1e-9*ro*A*L';


% Máximos e mínimos deslocamentos
deslmax=max(u);
deslmin=min(u);

% Máximas e mínimas tensões
tsmax=max(ts);
tsmin=min(ts);


function L=comprimento(cno,id,nel)

% Calcula o comprimento de cada elemento de uma trelica 2D
% L = [L1 L2 ... Lnel]

for i=1:nel
    noA=id(i,1);
    noB=id(i,2);
    xA=cno(noA,1);
    yA=cno(noA,2);
    xB=cno(noB,1);
    yB=cno(noB,2);
    L(i)=sqrt((yB-yA)^2+(xB-xA)^2);
end

function K=rigidez(cno,id,E,A,L)

%  Calcula a matriz de rigidez de uma trelica 2D

% Numero de nos - nno
[nno,i]=size(cno);

% Numero de elementos - nel
[nel,i]=size(id);

K=zeros(nno*2,nno*2);
for i=1:nel
    Ke1=(E*A(i)/L(i))*[1 0 -1 0; 0 0 0 0; -1 0 1 0; 0 0 0 0];
    T=zeros(4,4);
    T=rotacao(id,cno,L,i);
    Kex=T*Ke1*T';
    Kse=zeros(nno*2,nno*2);
    Kse=montagem(Kex,id,i,nno);
    K=K+Kse;
end

function f=carregamento(tp,nno)

% Monta o vetor de carregamentos nodais a partir das tracoes prescritas

f=zeros(nno*2,1);
[ntp,i]=size(tp);
for i=1:ntp
    no=tp(i,1);
    dir=tp(i,2);
    valor=tp(i,3);
    f((no-1)*2+dir,1)=valor;
end

function [Km,fm]=deslocamentos(K,f,dp)

% Aplica os deslocamentos prescritos

Km=K;
fm=f;
[ndp,i]=size(dp);
for i=1:ndp
    no=dp(i,1);
    dir=dp(i,2);
    valor=dp(i,3);
    Km((no-1)*2+dir,:)=0;
    Km(:,(no-1)*2+dir)=0;
    Km((no-1)*2+dir,(no-1)*2+dir)=1;
    fm((no-1)*2+dir,1)=valor;
end

function e=deformacao(u,id,cno,E,A,L)

% Calcula a deformacao de cada elemento a partir dos deslocamentos nodais

% Numero de nos - nno
[nno,i]=size(cno);

% Numero de elementos - nel
[nel,i]=size(id);

for i=1:nel
    noA=id(i,1);
    noB=id(i,2);
    ux(1,1)=u((noA-1)*2+1,1);
    ux(2,1)=u((noA-1)*2+2,1);
    ux(3,1)=u((noB-1)*2+1,1);
    ux(4,1)=u((noB-1)*2+2,1);
    T=rotacao(id,cno,L,i);
    uel=T'*ux;
    e(i)=(uel(3,1)-uel(1,1))/L(i);
end

function T=rotacao(id,cno,L,el)

% Calcula a matriz de rotacao T que relaciona coordenadas
% locais em coordenadas globais - T.v1=vx

noA=id(el,1);
noB=id(el,2);
xA=cno(noA,1);
yA=cno(noA,2);
xB=cno(noB,1);
yB=cno(noB,2);
l1=(xB-xA)/L(el);
m1=(yB-yA)/L(el);
T=zeros(4,4);
T(1,1)=l1;
T(1,2)=-m1;
T(2,1)=m1;
T(2,2)=l1;
T(3:4,3:4)=T(1:2,1:2);

function Kse=montagem(Kex,id,el,nno)

% Monta a matriz de rigidez do elemento na matriz de rigidez do sistema

Kse=zeros(nno*2,nno*2);
noA=id(el,1);
noB=id(el,2);
Kse((noA-1)*2+1,(noA-1)*2+1)=Kex(1,1);
Kse((noA-1)*2+1,(noA-1)*2+2)=Kex(1,2);
Kse((noA-1)*2+2,(noA-1)*2+1)=Kex(2,1);
Kse((noA-1)*2+2,(noA-1)*2+2)=Kex(2,2);
Kse((noB-1)*2+1,(noB-1)*2+1)=Kex(3,3);
Kse((noB-1)*2+1,(noB-1)*2+2)=Kex(3,4);
Kse((noB-1)*2+2,(noB-1)*2+1)=Kex(4,3);
Kse((noB-1)*2+2,(noB-1)*2+2)=Kex(4,4);
Kse((noA-1)*2+1,(noB-1)*2+1)=Kex(1,3);
Kse((noA-1)*2+1,(noB-1)*2+2)=Kex(1,4);
Kse((noA-1)*2+2,(noB-1)*2+1)=Kex(2,3);
Kse((noA-1)*2+2,(noB-1)*2+2)=Kex(2,4);
Kse((noB-1)*2+1,(noA-1)*2+1)=Kex(3,1);
Kse((noB-1)*2+1,(noA-1)*2+2)=Kex(3,2);
Kse((noB-1)*2+2,(noA-1)*2+1)=Kex(4,1);
Kse((noB-1)*2+2,(noA-1)*2+2)=Kex(4,2);