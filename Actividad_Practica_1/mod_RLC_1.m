function [X]=mod_RLC_1(t_etapa, xant, accion) 
R=47; L=1e-6; C=100e-9;
A=[-R/L -1/L; 1/C 0];
B=[1/L;0];
At=1e-9; %At=1e-13, el tiempo calculado
x=xant; 
u=accion; %v_e
for ii=1:t_etapa/At     
xp=A*x+B*u;
x=x+xp*At;
%Y = mod_RLC_1_sal(x);
end 
X=x;


