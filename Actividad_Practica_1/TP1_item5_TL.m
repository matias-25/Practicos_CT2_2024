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

%Identificación de la FT del sistema el torque de carga
StepTL=1e-3;%de los datos
t_2=0:0.6/(length(t)-1):0.6;%creo un vector tiempo equidistante
t_s=t_2(1:16688-16500+1); %seccion del escalon positivo con torque
w_s=flip(wr(16500:16688)); %se analiza la seccion del Escalon positivo con torque
y=w_s; 
t0=t_s;
t_inic=3.707e-5; 
[val lugar] =min(abs(t_inic-t0)); y_t1=y(lugar); 
t_t1=t0(lugar); 
ii=1; 
[val lugar] =min(abs(2*t_inic-t0)); 
t_2t1=t0(lugar); 
y_2t1=y(lugar); 
[val lugar] =min(abs(3*t_inic-t0)); 
t_3t1=t0(lugar); 
y_3t1=y(lugar); 
K=y(end)/StepTL; 
k1=(1/StepTL)*y_t1/K-1;%Afecto el valor del Escalon 
k2=(1/StepTL)*y_2t1/K-1; 
k3=(1/StepTL)*y_3t1/K-1; 
be=4*k1^3*k3-3*k1^2*k2^2-4*k2^3+k3^2+6*k1*k2*k3; 
alfa1=(k1*k2+k3-sqrt(be))/(2*(k1^2+k2)); 
alfa2=(k1*k2+k3+sqrt(be))/(2*(k1^2+k2)); 
beta=(k1+alfa2)/(alfa1-alfa2); 

T1_ang=-t_t1/log(alfa1); 
T2_ang=-t_t1/log(alfa2); 
T3_ang=beta*(T1_ang-T2_ang)+T1_ang; 
T1(ii)=T1_ang; 
T2(ii)=T2_ang; 
T3(ii)=T3_ang; 
T3_ang=sum(T3/length(T3)); 
T2_ang=sum(T2/length(T2)); 
T1_ang=sum(T1/length(T1)); 
sys_G_ang=tf(K*[T3_ang 1],conv([T1_ang 1],[T2_ang 1]))
[num,den] = tfdata(sys_G_ang);
y_id=StepTL*step(sys_G_ang , t_s );

figure(2);
plot(t_s,w_s,'r'),hold on
plot(t_t1,y_t1,'.')
plot(t_2t1,y_2t1,'*')
plot(t_3t1,y_3t1,'o')
plot(t_s,y_id,'k')
%step(StepAmplitude*G_Resul,'c');
legend('Real','Intervalo 1','Intervalo 2','Intervalo 3','Identificada','Con los elemetos calculados'); 
legend('boxoff');grid on
