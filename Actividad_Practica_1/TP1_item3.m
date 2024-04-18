clear;close all; 
T = readtable('Curvas_Medidas_RLC_2024.xls');
A = table2array(T);
t = [A(:,1)]; %tiempo en segundos
i = [A(:,2)]; %corriente 
v = [A(:,3)]; %tension en el capacitor

R=335.9111;
L=0.1232;
C=8.0081e-06;
num_cal=[0 0 1];
den_cal=[L*C R*C 1];
%G_Resul= tf(num_cal,den_cal);
%Calculos de los polos y tiempos de Euler
lamdas=roots(den_cal);
disp(lamdas);
if lamdas(1)<lamdas(2)
    lamda1=lamdas(1);
    lamda2=lamdas(2);
else
    lamda1=lamdas(2);
    lamda2=lamdas(1);
end
t1=log(0.95)/lamda1;    %tiempo rapido
t2=log(0.05)/lamda2;    %tiempo lento

X=-[0;0];ii=0;
t_etapa=t2/67.45;
tF=200e-3;
t_mio=0:t_etapa:tF; 
u_=12*square(2*pi*10*t_mio);
kk=int16(0.05*length(t_mio));
%u=[zeros(kk-1,1); u_(kk:end)];
u=[zeros(1,kk), u_(kk+1:end)];
for t_e=0:t_etapa:tF 
    ii=ii+1;
     X=mod_RLC_3(t_etapa, X, u(ii),t1); 
    x1(ii)=X(1);%Voltaje en el Capacitor
    x2(ii)=X(2);%Corriente del Inductor
    acc(ii)=u(ii);
end


figure(1);
subplot(3,1,1);
plot(t_mio,x2);hold on; plot(t,i,'r');title('Corriente-CALCULADA vs Corriente-MEDIDA Rojo'); grid on 
subplot(3,1,2);
plot(t,acc);title('Voltaje Aplicado'); grid on
subplot(3,1,3); 
plot(t,x1);%hold on;plot(t,v,'g'); title('Voltaje en el capacitor vs v-MEDIDO Verde'); grid on
xlabel('Tiempo [Seg.]');
