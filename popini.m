function P=popini(dimvar,nind)

% Tiago Franco de Goes Teles, 2010

% Gera a popula��o inicial aleatoriamente

% n�mero de vari�veis do problema - nvar
nvar=length(dimvar);

% n�mero de indiv�duos do problema

P=zeros(nind,nvar);
for i=1:nind
    for j=1:nvar
        P(i,j)=randi(dimvar(j),1);
    end
end