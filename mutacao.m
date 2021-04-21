function P=mutacao(P,tm,dimvar,ne)

% Tiago Franco de Goes Teles, 2010

% Aplica o operador muta��o na popula��o corrente segundo uma taxa
% de muta��o tm, preservando os indiv�duos da estrat�gia elitista

[nind,nvar]=size(P); % n�mero de indiv�duos (nind) e de vari�veis (nvar)

% N�mero de genes que sofrer�o muta��o - nm
nm=round(nvar*nind*tm);
if nm==0; nm=1; end

% Aplica��o da muta��o em "nm" genes, localizadas nos indiv�duos "ind" e
% nas vari�veis "var"
for i=1:nm
    ind=ne+randi((nind-ne),1);
    var=randi(nvar,1);
    P(ind,var)=randi(dimvar(var),1);
end