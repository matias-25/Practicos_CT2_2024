function [X]=modmotor_7(t_etapa, xant, accion)
Laa= 2.3870e-04; J=4.2578e-10;Ra=25.3177;B=0;Ki=0.0021;Km=0.0605;
A=[-Ra/Laa -Km/Laa 0; Ki/J -B/J 0; 0 1 0];
B=[1/Laa 0; 0 -1/J; 0 0];
u=accion;
x=xant;
h=1e-5;

for ii=1:t_etapa/h 
xp=A*x+B*u;
x=x+xp*h;
end
X=x;