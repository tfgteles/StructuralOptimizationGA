function P=popini(dimvar,nind)

% Tiago Franco de Goes Teles, 2010

% Gera a população inicial aleatoriamente

% número de variáveis do problema - nvar
nvar=length(dimvar);

% número de indivíduos do problema

P=zeros(nind,nvar);
for i=1:nind
    for j=1:nvar
        P(i,j)=randi(dimvar(j),1);
    end
end