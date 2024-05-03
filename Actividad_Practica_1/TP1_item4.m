clear;close all;
X=-[0;0;0];ii=0;t_etapa=1e-5;tF=5;
u=12;
t=0:t_etapa:tF;
TL=(((1.4e-3)/2)*square(2*pi*0.5*t)+((1.4e-3)/2)).*(t>=1);
for t_eu=0:t_etapa:tF
 ii=ii+1;k=ii+2;
 X=modmotor(t_etapa, X, [u,TL(ii)]);
 x1(ii)=X(1);%ia
 x2(ii)=X(2);%Omega
 x3(ii)=X(3);%wp
 acc(ii)=u;
end
figure(1)
subplot(3,1,1);
plot(t,x1,'r');title('Corriente');
subplot(3,1,2);
plot(t,x2,'r');title('Salida y, \omega_t');
subplot(3,1,3);
plot(t,acc,'r');hold on;plot(t,10e3*TL,'b'); title('Entrada v_a (rojo) , Torque (Azul, elcala 10e3)');
xlabel('Tiempo [Seg.]');

wRef=2000;
%Constantes del PID
%Kp=.500;Ki=0.001;Kd=0.0001;color_='r';
% Kp=1;Ki=0;Kd=0.0001;color_='k';
% Kp=10;Ki=0;Kd=0;color_='b';
Kp=0.004;Ki=1;Kd=1e-9;color_='c';
Ts=t_etapa;
A1=((2*Kp*Ts)+(Ki*(Ts^2))+(2*Kd))/(2*Ts);
B1=(-2*Kp*Ts+Ki*(Ts^2)-4*Kd)/(2*Ts);
C1=Kd/Ts;
e=zeros(uint64(tF/t_etapa),1);
u=0;ii=0; %reinicio mis variables
for t_eu2=0:t_etapa:tF
 ii=ii+1;k=ii+2;
 X=modmotor(t_etapa, X, [u,TL(ii)]);
 e(k)=wRef-X(2); %ERROR
 u=u+A1*e(k)+B1*e(k-1)+C1*e(k-2); %PID
 x1(ii)=X(1);%ia
 x2(ii)=X(2);%Omega
 x3(ii)=X(3);%wp
 acc(ii)=u;
end

figure(2)
subplot(3,1,1);
plot(t,x1,'r');title('Corriente');
subplot(3,1,2);
plot(t,x2,'r');title('Salida y, \omega_t');
subplot(3,1,3);
plot(t,acc,color_);hold on;plot(t,1e3*TL,'b'); title('Entrada v_a (rojo) , Torque (Azul, elcala 1e3)');
xlabel('Tiempo [Seg.]');
