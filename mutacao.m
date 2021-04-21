function P=mutacao(P,tm,dimvar,ne)

% Tiago Franco de Goes Teles, 2010

% Aplica o operador mutação na população corrente segundo uma taxa
% de mutação tm, preservando os indivíduos da estratégia elitista

[nind,nvar]=size(P); % número de indivíduos (nind) e de variáveis (nvar)

% Número de genes que sofrerão mutação - nm
nm=round(nvar*nind*tm);
if nm==0; nm=1; end

% Aplicação da mutação em "nm" genes, localizadas nos indivíduos "ind" e
% nas variáveis "var"
for i=1:nm
    ind=ne+randi((nind-ne),1);
    var=randi(nvar,1);
    P(ind,var)=randi(dimvar(var),1);
end