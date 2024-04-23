clear;close all;
X=-[0; 0];ii=0;t_etapa=1e-7;tF=.5;
u=12;
TL=1.409352518e-3;
for t=0:t_etapa:tF
 ii=ii+1;k=ii+2;
 X=modmotor(t_etapa, X, [u,TL]);
 x1(ii)=X(1);%Omega
 x2(ii)=X(2);%wp
 acc(ii)=u;
end
t=0:t_etapa:tF;
subplot(2,1,1);hold on;
plot(t,x1,'r');title('Salida y, \omega_t');
subplot(2,1,2);hold on;
plot(t,acc,'r');title('Entrada u_t, v_a');
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

