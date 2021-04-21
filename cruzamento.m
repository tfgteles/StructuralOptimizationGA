function P2=cruzamento(P1,sel)

% Tiago Franco de Goes Teles, 2010

% Gera uma nova popula��o a partir dos indiv�duos selecionados (sel) para
% cruzar e completa o n�mero total de indiv�duos usando estrat�gia
% elitista (elit)

[nind,nvar]=size(P1); % n�mero de indiv�duos (nind) e de vari�veis (nvar)
nc=length(sel); % n�mero de indiv�duos para cruzamento
ne=nind-nc; % n�mero de indiv�duos para estrat�gia elitista
P2=zeros(nind,nvar);
P2(1:ne,:)=P1(1:ne,:);


% Aplica��o do operador cruzamento
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