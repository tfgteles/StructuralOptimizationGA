function [P,sel,ne]=selecao(P,popadap,tc,tpsel)

% Tiago Franco de Goes Teles, 2010

% Gera um vetor "sel" que indica a sele��o dos indiv�duos de uma
% popula��o que ir�o cruzar para gerar novos indiv�duos e o vetor
% "elit" que indica a sele��o dos indiv�duos que ir�o completar
% a nova popula��o aplicando a estrat�gia elitista

% O m�todo de sele��o depende da vari�vel "tpsel"
% tpsel=1: "Stochastic Universal Sampling (SUS)"
% tpsel=2: M�todo da roleta

[nind,nvar]=size(P); % n�mero de indiv�duos (nind) e de vari�veis (nvar)
% Classifica��o dos indiv�duos da popula��o do melhor para o pior
[popadap,perm]=sort(popadap);
P1=P; P=zeros(nind,nvar);
for i=1:nind
    P(i,:)=P1(perm(i,1),:);
end

% Determina��o do n�mero de indiv�duos para cruzamento - nc
nc=2*(round(nind*tc/2));

% Aplica��o do m�todo "Stochastic Universal Sampling (SUS)"
if tpsel==1
    sel=randi(nind,nc,1);
end
% Aplica��o do m�todo da roleta
if tpsel==2
    nota1=popadap-min(popadap);
    padrao=2*mean(nota1);
    fim=0;
    for i=1:nind
        nota(i)=round(10*(1-min((nota1(i,1)/padrao),1)));
        ini=fim+1;
        fim=ini+nota(i)-1;
        roleta(ini:fim)=i;
    end
    nrol=length(roleta);
    for i=1:nc
        sel(i,1)=roleta(randi(nrol));
    end
end
        

% N�mero de indiv�duos para estrat�gia elitista
ne=nind-nc;


