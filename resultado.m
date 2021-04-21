function [Sol,adap]=resultado(P,popadap,var,nsol)

% Tiago Franco de Goes Teles, 2010

% Apresenta os "nsol" melhores indivíduos depois de se obter a
% convergência, "Sol" são as variáveis de cada um e adap o valor
% da função objetivo de cada um

[nvar,i]=size(var); % número de variáveis do problema
[popadap,perm]=sort(popadap);
adap=popadap(1:nsol,1);
for i=1:nsol
    for j=1:nvar
        Sol(i,j)=var(j,P(perm(i,1),j));
    end
end
