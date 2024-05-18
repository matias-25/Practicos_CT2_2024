clear;close all;
X=-[0;0;0];ii=0;t_etapa=1e-6;tF=0.6;
t_=0:t_etapa:tF;
u=12*(t_>0.036);
TL_=(((1e-3)/2)*(square(2*pi*3.33*(t_-0.1863)))+(1e-3)/2).*(t_>=0.036);
for t_eu=0:t_etapa:tF
 ii=ii+1;k=ii+2;
 X=modmotor_5(t_etapa, X, [u(ii),TL_(ii)]);
 x1(ii)=X(1);%ia
 x2(ii)=X(2);%Omega
 x3(ii)=X(3);%wp
 acc(ii)=u(ii);
end

A = xlsread('Curvas_Medidas_Motor_2024');
t   = A(:,1); %tiempo en segundos
wr  = A(:,2); %velocidad angular [Rad/seg] 
ia  = A(:,3); %corriente de armadura[A]
v_m = A(:,4); %Voltaje de entrada
TL  = A(:,5); %Torque de Carga

figure(1)
subplot(4,1,1);
plot(t_,x2,'r');hold on;plot(t,wr);title('Salida y, \omega_t');
legend('Con los elemetos calculados','Real'); 
subplot(4,1,2);
plot(t_,x1,'r');hold on;plot(t,ia);title('Corriente');
legend('Con los elemetos calculados','Real');  
subplot(4,1,3);
plot(t_,acc,'r');hold on;plot(t,v_m);title('Entrada v_a');
legend('Con los elemetos calculados','Real'); 
subplot(4,1,4);
plot(t_,TL_,'r');hold on;plot(t,TL);title('Torque)');
legend('Con los elemetos calculados','Real');  
xlabel('Tiempo [Seg.]');