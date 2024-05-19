clear;close all;
X=-[0;0;0;0];ii=0;t_etapa=1e-5;tF=1;
u=12;
t=0:t_etapa:tF;
%TL=(((1.4e-3)/2)*square(2*pi*0.5*t)+((1.4e-3)/2)).*(t>=1);
TL=0;
for t_eu=0:t_etapa:tF
 ii=ii+1;k=ii+2;
 X=modmotor_6(t_etapa, X, [u,TL]);
 x1(ii)=X(1);%ia
 x2(ii)=X(2);%Omega
 x3(ii)=X(3);%wp
 x4(ii)=X(4);%tita
 acc(ii)=u;
end
figure(1)
subplot(4,1,1);
plot(t,x1,'r');title('Corriente'); grid on;
subplot(4,1,2);
plot(t,x2,'r');title(' \omega_t'); grid on;
subplot(4,1,3);
plot(t,acc,'r');hold on;plot(t,10e3*TL,'b'); title('Entradas'); grid on;
legend('v_a ','Torque (elcala 10e3)');
subplot(4,1,4);
plot(t,x4,'r');title('Salida y, \theta'); grid on;
xlabel('Tiempo [Seg.]');

titaRef=1; %radian
%Constantes del PID
Kp=10;Ki=0.01;Kd=5e-5;color_='r';
% Kp=1;Ki=0;Kd=0.0001;color_='k';
% Kp=10;Ki=0;Kd=0;color_='b';
Ts=t_etapa;
A1=((2*Kp*Ts)+(Ki*(Ts^2))+(2*Kd))/(2*Ts);
B1=(-2*Kp*Ts+Ki*(Ts^2)-4*Kd)/(2*Ts);
C1=Kd/Ts;
e=zeros(uint64(tF/t_etapa),1);
X=-[0;0;0;0];u=0;ii=0; %reinicio mis variables
for t_eu2=0:t_etapa:tF
 ii=ii+1;k=ii+2;
 X=modmotor_6(t_etapa, X, [u,TL]);
 e(k)=titaRef-X(4); %ERROR
 u=u+A1*e(k)+B1*e(k-1)+C1*e(k-2); %PID
 x1(ii)=X(1);%ia
 x2(ii)=X(2);%Omega
 x3(ii)=X(3);%wp
 x4(ii)=X(4);%tita
 acc(ii)=u;
end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        

figure(2)
subplot(4,1,1);
plot(t,x1,'r');grid on; title('Corriente');
subplot(4,1,2);
plot(t,x2,'r');grid on;title('\omega_t');
subplot(4,1,3);
plot(t,acc,'r');hold on;plot(t,10e3*TL,'b'); title('Entradas'); grid on;
legend('v_a ','Torque (elcala 10e3)');
subplot(4,1,4);
plot(t,x4,'r');grid on;title('Salida y, \theta');
xlabel('Tiempo [Seg.]');