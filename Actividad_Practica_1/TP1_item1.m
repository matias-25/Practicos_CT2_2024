clear;close all; 
X=-[0;0];ii=0;t_etapa=1e-9;tF=5e-3;
%Y=[0;0];
%y=0; %salida
t=0:t_etapa:tF; 
Ts=t_etapa; 
u=((12)*square(2*pi*500*(t-1e-3))+(0)).*(t>=1e-3);

for t_=0:t_etapa:tF 
    ii=ii+1;
    X=mod_RLC_1(t_etapa, X, u(ii)); 
  %  Y=mod_RLC_1_sal(t_etapa, X, u(ii)); 
    x1(ii)=X(1);%Corriente del Inductor
    x2(ii)=X(2);%Voltaje en el Capacitor
    acc(ii)=u(ii);
   % y(ii)=Y(1);%Voltaje en la resistencia, salida
end 
figure(1);
subplot(3,1,1);hold on; 
plot(t,x1);title('Corriente'); grid on 
subplot(3,1,2);hold on; 
plot(t,acc);title('Voltaje Aplicado'); grid on
subplot(3,1,3);hold on; 
plot(t,x2);title('Voltaje en el capacitor'); grid on
xlabel('Tiempo [Seg.]');

%figure(2);
%subplot(3,1,1);hold on; 
%plot(t,y);title('Salida'); grid on 
%subplot(3,1,2);hold on; 
%plot(t,acc);title('Entrada Voltaje Aplicado'); grid on
