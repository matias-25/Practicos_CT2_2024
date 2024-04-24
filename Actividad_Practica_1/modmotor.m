function [X]=modmotor(t_etapa, xant, accion)
Laa=366e-6; J=5e-9;Ra=55.6;B=0;Ki=6.49e-3;Km=6.53e-3;
Va=accion(1);
TL=accion(2);
TLp=0;
h=1e-7;
ia=xant(1);
omega= xant(2);
wp=xant(3);
for ii=1:t_etapa/h 
 wpp =(-wp*(Ra*J+Laa*B)-omega*(Ra*B+Ki*Km)+Va*Ki-Laa*TLp-Ra*TL)/(J*Laa);
 wp=wp+h*wpp;
 omega = omega + h*wp;
 iap=(-Ra*ia-Km*omega+Va)/Laa;
 ia=ia+iap*h;
 end
X=[ia,omega,wp];
