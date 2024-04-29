close all; clear;
A = xlsread('Curvas_Medidas_Motor_2024');
t   = A(:,1); %tiempo en segundos
wr  = A(:,2); %velocidad angular [Rad/seg] 
ia  = A(:,3); %corriente de armadura[A]
v_m = A(:,4); %Voltaje de entrada
TL  = A(:,5); %Torque de Carga

figure(1);
subplot(4,1,1);
plot(t,wr); title('velocidad angular [Rad/seg], wr'); grid on;
subplot(4,1,2);
plot(t,ia);title('Corriente armadura [A], ia'); grid on;
subplot(4,1,3);
plot(t,v_m);title('Tension [V]'); grid on;
subplot(4,1,4);
plot(t,TL);title('Torque de Carga [Nm]'); grid on;