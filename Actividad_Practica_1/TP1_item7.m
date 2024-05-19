clear;close all;
X=-[0;0;0];ii=0;k=ii+2;t_etapa=1e-5;tF=10;
t=0:t_etapa:tF;
u=0;
TL=(((1.15e-3)/2)*(square(2*pi*0.25*(t-0)))+(1.15e-3)/2).*(t>=1);

%titaRef=pi/2; %radian
titaRef=((pi/2)*(square(2*pi*0.25*(t-0)))).*(t>=0);
%Constantes del PID
Kp=5;Ki=200;Kd=5e-5;color_='r';

Ts=t_etapa;
A1=((2*Kp*Ts)+(Ki*(Ts^2))+(2*Kd))/(2*Ts);
B1=(-2*Kp*Ts+Ki*(Ts^2)-4*Kd)/(2*Ts);
C1=Kd/Ts;
e=zeros(uint64(tF/t_etapa),1);
for t_eu2=0:t_etapa:tF
 ii=ii+1;k=ii+2;
 if titaRef(ii)==-pi/2
     TL(ii)=0;
 end
 X=modmotor_7(t_etapa, X, [u;TL(ii)]);
 e(k)=titaRef(ii)-X(3); %ERROR
 u=u+A1*e(k)+B1*e(k-1)+C1*e(k-2); %PID
 x1(ii)=X(1);%ia
 x2(ii)=X(2);%Omega
 x3(ii)=X(3);%tita
 acc(ii)=u;
end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        

figure(1)
subplot(4,1,1);
plot(t,x1,'r');grid on; title('Corriente');
subplot(4,1,2);
plot(t,x2,'r');grid on;title('\omega_t');
subplot(4,1,3);
plot(t,acc,'r');hold on;plot(t,10e3*TL,'b'); title('Entradas'); grid on;
legend('v_a ','Torque (elcala 10e3)');
subplot(4,1,4);
plot(t,x3,'r');hold on;plot(t,titaRef,'y');title(', \theta');grid on;
legend('Salida y \theta','\theta de Referencia');
xlabel('Tiempo [Seg.]');

