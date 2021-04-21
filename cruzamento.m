function P2=cruzamento(P1,sel)

% Tiago Franco de Goes Teles, 2010

% Gera uma nova população a partir dos indivíduos selecionados (sel) para
% cruzar e completa o número total de indivíduos usando estratégia
% elitista (elit)

[nind,nvar]=size(P1); % número de indivíduos (nind) e de variáveis (nvar)
nc=length(sel); % número de indivíduos para cruzamento
ne=nind-nc; % número de indivíduos para estratégia elitista
P2=zeros(nind,nvar);
P2(1:ne,:)=P1(1:ne,:);


% Aplicação do operador cruzamento
for i=1:(nc/2)
    pai(1,:)=P1(sel(2*i-1),:);
    pai(2,:)=P1(sel(2*i),:);
    [f1,f2]=cross(pai,nvar);
    P2(ne+2*i-1,:)=f1;
    P2(ne+2*i,:)=f2;
end

function [f1,f2]=cross(pai,nvar)
for i=1:nvar
    if randi(2,1)==1
        f1(i)=pai(1,i);
        f2(i)=pai(2,i);
    else
        f1(i)=pai(2,i);
        f2(i)=pai(1,i);
    end
end