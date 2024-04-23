clear;close all;
X=-[0; 0];ii=0;t_etapa=1e-7;tF=.5;
u=12;
%TL=1.409352518e-3;
t=0:t_etapa:tF;
V_TL=(t>=0.3).*(t-0.3);
w=zeros(1,length(t));

for t_eu=0:t_etapa:tF
 ii=ii+1;
 X=modmotor(t_etapa, X, [u,V_TL(ii)]);
 x1(ii)=X(1);%Omega
 x2(ii)=X(2);%wp
 acc(ii)=u;
 if x1(ii)>=0 && x1(ii)<0.1 && t_eu>0.1
     w(ii)=x1(ii);
     disp('Torque Max');
     disp(V_TL(ii));
     disp('Velocidad con TL max');
     disp(w(ii));
 end 
end

subplot(2,1,1);hold on;
plot(t,x1,'r');hold on;plot(t,w);  ylim([-10 2000]); grid on;title('Salida y, \omega_t');
subplot(2,1,2);hold on;
plot(t,V_TL,'r');title('Totque de Carca');
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
