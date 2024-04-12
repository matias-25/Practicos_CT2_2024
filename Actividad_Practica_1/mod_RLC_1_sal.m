function [Y] = mod_RLC_1_sal(t_etapa, xant, accion)
%MOD_RLC_1_SAL Summary of this function goes here
%   Detailed explanation goes here
R=47; L=1e-6; C=100e-9;
A=[-R/L -1/L; 1/C 0];
B=[1/L;0];
C_t=[R 0];
At=1e-9; %At=1e-10, pero le pongo 10veces menos porque mi compu no lo soporta
x=xant; 
u=accion; %v_e
for ii=1:t_etapa/At     
xp=A*x+B*u;
x=x+xp*At;
y=C_t*x;
end
Y=y;
