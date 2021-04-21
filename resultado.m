function [Sol,adap]=resultado(P,popadap,var,nsol)

% Tiago Franco de Goes Teles, 2010

% Apresenta os "nsol" melhores indiv�duos depois de se obter a
% converg�ncia, "Sol" s�o as vari�veis de cada um e adap o valor
% da fun��o objetivo de cada um

[nvar,i]=size(var); % n�mero de vari�veis do problema
[popadap,perm]=sort(popadap);
adap=popadap(1:nsol,1);
for i=1:nsol
    for j=1:nvar
        Sol(i,j)=var(j,P(perm(i,1),j));
    end
end
