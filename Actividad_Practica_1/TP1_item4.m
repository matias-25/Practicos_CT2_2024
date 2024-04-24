clear;close all;
X=-[0;0;0];ii=0;t_etapa=1e-5;tF=5;
u=12;
t=0:t_etapa:tF;
TL=(1.4e-3)*(t>=1);
for t_eu=0:t_etapa:tF
 ii=ii+1;k=ii+2;
 X=modmotor(t_etapa, X, [u,TL(ii)]);
 x1(ii)=X(1);%ia
 x2(ii)=X(2);%Omega
 x3(ii)=X(3);%wp
 acc(ii)=u;
end
subplot(3,1,1);
plot(t,x1,'r');title('Corriente');
subplot(3,1,2);
plot(t,x2,'r');title('Salida y, \omega_t');
subplot(3,1,3);
plot(t,acc,'r');hold on;plot(t,10e3*TL,'b'); title('Entrada v_a (rojo) , Torque (Azul, elcala 10e3)');
xlabel('Tiempo [Seg.]');
% % Para verificar
% Laa=366e-6;
% J=5e-9;
% Ra=55.6;
% B=0;
% Ki=6.49e-3;
% Km=6.53e-3;
% num=[Ki]
% den=[Laa*J Ra*J+Laa*B Ra*B+Ki*Km ]; %wpp*Laa*J+wp*(Ra*J+Laa*B)+w*(Ra*B+Ki*Km)=Vq*Ki
% sys=tf(num,den)
% step(sys)

