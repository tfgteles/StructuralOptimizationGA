function c=convergencia(popadap,tol)

% Tiago Franco de Goes Teles, 2010

% Verifica se o método convergiu

popadap=sort(popadap);
nind=length(popadap);
popadap=popadap-popadap(1,1);
padrao=mean(popadap(1:round(nind*0.8),1));
div=abs(popadap(1,1)-padrao)/abs(padrao);

if div<=tol
    c=1;
else
    c=0;
end