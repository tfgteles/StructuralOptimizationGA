function [P,sel,ne]=selecao(P,popadap,tc,tpsel)

% Tiago Franco de Goes Teles, 2010

% Gera um vetor "sel" que indica a seleção dos indivíduos de uma
% população que irão cruzar para gerar novos indivíduos e o vetor
% "elit" que indica a seleção dos indivíduos que irão completar
% a nova população aplicando a estratégia elitista

% O método de seleção depende da variável "tpsel"
% tpsel=1: "Stochastic Universal Sampling (SUS)"
% tpsel=2: Método da roleta

[nind,nvar]=size(P); % número de indivíduos (nind) e de variáveis (nvar)
% Classificação dos indivíduos da população do melhor para o pior
[popadap,perm]=sort(popadap);
P1=P; P=zeros(nind,nvar);
for i=1:nind
    P(i,:)=P1(perm(i,1),:);
end

% Determinação do número de indivíduos para cruzamento - nc
nc=2*(round(nind*tc/2));

% Aplicação do método "Stochastic Universal Sampling (SUS)"
if tpsel==1
    sel=randi(nind,nc,1);
end
% Aplicação do método da roleta
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
        

% Número de indivíduos para estratégia elitista
ne=nind-nc;


