clear;close all; 
X=-[0;0];ii=0;t_etapa=1e-9;tF=5e-3;
Y=[0;0];
y=0; %salida
Ts=t_etapa; 
u=0; %12V
divaux= tF/1e-3;
aux=0:t_etapa:tF;
aux1=int64((length(aux)/divaux)); 
aux2=int64((2*length(aux)/divaux));
j=0;
for t=0:t_etapa:tF 
    ii=ii+1;
    j=j+1;
    if j== aux1 %cambia a los 1ms
       u=12;
    end
    if j== aux2 %cambia a los 1ms
       u=-12;
       j=0;
    end
    X=mod_RLC_1(t_etapa, X, u); 
    Y=mod_RLC_1_sal(t_etapa, X, u); 
    x1(ii)=X(1);%Corriente del Inductor
    x2(ii)=X(2);%Voltaje en el Capacitor
    acc(ii)=u;
    y(ii)=Y(1);%Voltaje en la resistencia, salida
end 
t=0:t_etapa:tF; 
figure(1);
subplot(3,1,1);hold on; 
plot(t,x1);title('Corriente'); grid on 
subplot(3,1,2);hold on; 
plot(t,acc);title('Voltaje Aplicado'); grid on
subplot(3,1,3);hold on; 
plot(t,x2);title('Voltaje en el capacitor'); grid on
xlabel('Tiempo [Seg.]');

figure(2);
subplot(3,1,1);hold on; 
plot(t,y);title('Salida'); grid on 
subplot(3,1,2);hold on; 
plot(t,acc);title('Voltaje Aplicado'); grid on
