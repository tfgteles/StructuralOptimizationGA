function popadap=fobjetivo(P,var)

% Tiago Franco de Goes Teles, 2010

% Calcula o valor da fun��o objetivo de cada indiv�duo da popula��o P

% n�mero de indiv�duos (nind), n�mero de vari�veis (nvar)
[nind,nvar]=size(P); % n�mero de indiv�duos - nind


for i=1:nind
    for j=1:nvar
        x(j)=var(j,P(i,j));
    end
    popadap(i,1)=funcao(x);
end

function f=funcao(x)

% Calcula o valor da fun��o objetivo do indiv�duo "i" dados os valores
% das vari�veis de projeto
[peso,tsmax,tsmin,deslmax,deslmin]=trelica2d(x);
% Restri��o de desigualdade (g<=0), fator de penalidade (pg)
if abs(deslmin)>abs(deslmax)
    g1=abs(deslmin)-50.8;
else
    g1=abs(deslmax)-50.8;
end
pg1=1000;
if abs(tsmin)>abs(tsmax)
    g2=abs(tsmin)-172;
else
    g2=abs(tsmax)-172;
end
pg2=1000;

% Restri��o de igualdade (h=0), fator de penalidade (ph)
h=0;
ph=1000;

% Fun��o objetivo incorporando as restri��es
rest=pg1*max(g1,0)+pg2*max(g2,0)+ph*h;

f=rest+peso;