function [X]=modmotor_6(t_etapa, xant, accion)
Laa= 2.3870e-04; J=4.2578e-10;Ra=25.3177;B=0;Ki=0.0021;Km=0.0605;
Va=accion(1);
TL=accion(2);
TLp=0;
h=1e-6;
ia=xant(1);
omega= xant(2);
wp=xant(3);
tita=xant(4);
for ii=1:t_etapa/h 
 iap= (-Ra*ia-Km*omega+Va)/Laa;
 ia= ia+iap*h;
 wpp =(-wp*(Ra*J+Laa*B)-omega*(Ra*B+Ki*Km)+Va*Ki-6.5^-1*Laa*TLp-6.5^-1*Ra*TL)/(J*Laa);
 wp=wp+h*wpp;
 omega = omega + h*wp;
 titap= omega;
 tita= tita + h*titap;
 end
X=[ia,omega,wp,tita];