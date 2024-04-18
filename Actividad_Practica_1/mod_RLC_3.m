function [X]=mod_RLC_3(t_etapa, xant, accion,tiempo) 
R=335.9111;
L=0.1232;
C=8.0081e-06;
%A=[-R/L -1/L; 1/C 0];
%B=[1/L;0];
A=[0 1;-1/(L*C) -R/L];
B=[0;1/L];
At=tiempo/3;
x=xant; 
u=accion; %v_e
for ii=1:t_etapa/At     
xp=A*x+B*u;
x=x+xp*At;
end 
X=x;


