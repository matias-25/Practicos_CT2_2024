close all; clear;
T = readtable('Curvas_Medidas_RLC_2024.xls');
A = table2array(T);
t = [A(:,1)]; %tiempo en segundos
i = [A(:,2)]; %corriente 
v = [A(:,3)]; %tension en el capacitor

StepAmplitude=12;

t_s=t(100:500)-0.01; %dezplazo el eje t, para analizar la seccion del escalon positivo
v_s=v(100:500); %se analiza la seccion del Escalon positivo 
y=v_s; 
t0=t_s;
t_inic=0.003; 
[val lugar] =min(abs(t_inic-t0)); y_t1=y(lugar); 
t_t1=t0(lugar); 
ii=1; 
[val lugar] =min(abs(2*t_inic-t0)); 
t_2t1=t0(lugar); 
y_2t1=y(lugar); 
[val lugar] =min(abs(3*t_inic-t0)); 
t_3t1=t0(lugar); 
y_3t1=y(lugar); 
K=y(end)/StepAmplitude; 
k1=(1/StepAmplitude)*y_t1/K-1;%Afecto el valor del Escalon 
k2=(1/StepAmplitude)*y_2t1/K-1; 
k3=(1/StepAmplitude)*y_3t1/K-1; 
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
y_id=StepAmplitude*step(sys_G_ang , t_s );

%Cálculo de componentes
%cin =condiciones iniciales nulas
imax_cin=0;
timax_cin=0;
tam_tv=0;
for jj=1:1:length(t)-1
    if i(jj+1)>=i(jj) && timax_cin==0
    imax_cin=i(jj);
    else 
    timax_cin=t(jj); 
    end
    if v(jj)>0 && tam_tv==0
        tam_tv=jj-1;
    end
end
V=12;
R=V/imax_cin;
aux_den=cell2mat(den);

C=(aux_den(2))/R;
L=(aux_den(1))/C;
num_cal=[0 0 1];
den_cal=[L*C R*C 1];
G_Resul= tf(num_cal,den_cal);
u_=12*square(2*pi*10*t);
u=[zeros(tam_tv-1,1); u_(tam_tv:end)];
ycal=lsim(G_Resul, u,t);
disp('R=');
disp(R);
disp('L=');
disp(L);
disp('C=');
disp(C);

figure(1);
subplot(2,1,1);
plot(t,i,'r'); title('Corriente'); grid on; 
subplot(2,1,2);
plot(t,v);title('Tension en el capacitor, salida y'); grid on; hold on; plot(t,ycal,'c');

figure(2);
plot(t_s,v_s,'r'),hold on
plot(t_t1,y_t1,'.')
plot(t_2t1,y_2t1,'*')
plot(t_3t1,y_3t1,'o')
plot(t_s,y_id,'k')
step(StepAmplitude*G_Resul,'c');
legend('Real','Intervalo 1','Intervalo 2','Intervalo 3','Identificada','Con los elemetos calculados'); 
legend('boxoff');grid on