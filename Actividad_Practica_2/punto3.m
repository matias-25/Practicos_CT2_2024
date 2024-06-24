close all;clear all;
m=.1;Fricc=0.1; long=0.6;g=9.8;M=.5;
%TIEMPOS: de muestreo, de simulación, de Euler y su integración
Ts=0.01;KMAX=100000-1;Veces_Euler=100;h=Ts/Veces_Euler;t_d=(0:KMAX)*Ts;
TamanioFuente=14;
ref1=10;ref2=0;
zona_muerta=20;
%Condiciones iniciales
alfa(1)=pi; color='g';colorc='r'; color_='b';
%Versión linealizada en el equilibrio estable
Mat_Ac=[0 1 0 0;0 -Fricc/M -m*g/M 0; 0 0 0 1; 0 -Fricc/(long*M) -g*(m+M)/(long*M) 0];
Mat_Bc=[0; 1/M; 0; 1/(long*M)];
Mat_C=[1 0 0 0;0 0 1 0]; I=eye(4);
H=[0;0;0;0];d_tao=Ts/100;tao=0;
for hh=1:100
 dH=expm(Mat_Ac*tao)*Mat_Bc*d_tao;
 H=H+dH;
 tao=tao+d_tao;
end
Mat_B=H;
Mat_A=expm(Mat_Ac*Ts);
Mat_Aa=[Mat_A,zeros(4,1);-Mat_C(1,:)*Mat_A, 1];
Mat_Ba=[Mat_B;-Mat_C(1,:)*Mat_B];
Qc=diag([1e1 1e0 1e0 1e-6 1e-6]); R=1e2; %Ts=1;
[Ka,Pc,E]=dlqr(Mat_Aa,Mat_Ba,Qc,R); %En Octave
K=Ka(1:4);KI=-Ka(5);
%Cálculo del Observador de estados
Mat_Adual=Mat_A';Mat_Bdual=Mat_C';Mat_Cdual=Mat_B';
Mat_Qobs=[Mat_C;Mat_C*Mat_A;Mat_C*Mat_A^2;Mat_C*Mat_A^3];
rango_matriz_obs=rank(Mat_Qobs);
Qobs=diag([100 10000 100000 .1]);Ro=diag([1e0 1e0]);
%Contrucción del Hamiltoniano para el cálculo del Observador
Ho=inv([eye(4) Mat_Bdual*inv(Ro)*Mat_Bdual'; zeros(4) Mat_Adual'])*[Mat_Adual zeros(4);-Qobs eye(4)];
[Vo,Do]=eig(Ho);MX1X2=[];
for ii=1:8
 if abs(Do(ii,ii))<1
 MX1X2=[MX1X2 Vo(:,ii)];
 end
end
MX1o=MX1X2(1:4,:); MX2o=MX1X2(5:8,:);
Po=real(MX2o*inv(MX1o)); % [K1o,Po,Eo]=dlqr(Mat_Adual,Mat_Bdual,Qobs,Ro);
Kobs=(inv(Ro+Mat_Bdual'*Po*Mat_Bdual)*Mat_Bdual'*Po*Mat_Adual)';
p_observador=abs(eig(Mat_A-Kobs*Mat_C)); %Verifica polos de observabilidad
t=0; x=[0;0;alfa(1);0];x_hat=[0;0;0;0];
p(1)=x(1); p_p(1)=x(2); alfa(1)=x(3); omega(1)=x(4);ve1(1)=0;ve2(1)=0;
p_(1)=0;p_p_(1)=0;alfa_(1)=0;omega_(1)=0; u_k(1)=0;
for ki=2:KMAX
 t=[t (ki-1)*Ts];
 Y_=Mat_C*x; %Se mide ACÁ
 e1=ref1-Y_(1);e2=ref2-Y_(2);
 ve1(ki)=ve1(ki-1)+e1;ve2(ki)=ve2(ki-1)+e2;
 u=-Ka*[x_hat;ve1(ki)];%Estado ampliado
 x=Mat_A*x+Mat_B*u;
 y_hat=Mat_C*x_hat;
 x_hat=Mat_A*x_hat+Mat_B*u+Kobs*(Y_-y_hat);%Se actualiza acá
 p(ki)=x(1);
 p_p(ki)=x(2);
 alfa(ki)=x(3);
 omega(ki)=x(4); 
 u_k(ki)=u;
end
figure(1);
subplot(3,2,1);plot(t,omega,color);
subplot(3,2,2);plot(t,alfa,color);
subplot(3,2,3); plot(t,p,color);
subplot(3,2,4);plot(t,p_p,color);
subplot(3,1,3);plot(t,u,color);
%Verificación de la solución con el modelo no lineal en tiempo continuo.
T=t(ki);x=[0;0;alfa(1);0];
p=x(1); p_p=x(2); alfa=x(3); omega=x(4); tita_pp(1)=0;p_pp(1)=0;
u=[];i=1;
x_hat=[0;0;0;0];y=Mat_C*x;y_hat=0;ve1(1)=0;ve2(1)=0;alfa_(1)=alfa(1);
xop=[0;0;pi;0];
for ki=2:KMAX+1
 Y_=Mat_C*x;
 ve1(ki)=ve1(ki-1)+ref1-Y_(1);
 ve2(ki)=ve2(ki-1)+ref2-Y_(2);
 u1(ki)=-Ka*[x_hat+xop;ve1(ki)];
 if abs(u1(ki))<zona_muerta
 u1(ki)=0;
 else
 u1(ki)=sign(u1(ki))*(abs(u1(ki))-zona_muerta);
 end
 for kii=1:Veces_Euler % Tiene relacion h con Ts
 u(i)=u1(ki);
 p_pp=(1/(M+m))*(u(i)-m*long*tita_pp*cos(alfa(i))+m*long*omega(i)^2*sin(alfa(i))-Fricc*p_p(i));
 tita_pp=(1/long)*(g*sin(alfa(i))-p_pp*cos(alfa(i)));
 p_p(i+1)=p_p(i)+h*p_pp;
 p(i+1)=p(i)+h*p_p(i+1);
 omega(i+1)=omega(i)+h*tita_pp;
 alfa(i+1)=alfa(i)+h*omega(i+1);
 alfa_(i)=x_hat(3);
 i=i+1;
 end
 x=[p(i-1); p_p(i-1); alfa(i-1); omega(i-1)]; %Acá está x(k+1)
 if x(1)>9.9
 ref1=0;
 m=1;
 end
 x_hat=Mat_A*(x_hat-xop)+Mat_B*u1(ki)+Kobs*(Y_-y_hat);
 y_hat=Mat_C*(x_hat);
end
u(i)=u1(ki);t=(1:i)*h;
figure(2);
subplot(3,2,1);plot(t,alfa,colorc);grid on;title('\phi_t','FontSize',TamanioFuente);hold on;axis([0 Ts*KMAX 2.5 3.5]);
subplot(3,2,2);plot(t,omega,colorc);grid on; 
title('$\dot{\phi_t}$','Interpreter','latex','FontSize',TamanioFuente);hold on;axis([0 Ts*KMAX -.5 .5]);
subplot(3,2,3); plot(t,p,colorc);grid on;title('\delta_t','FontSize',TamanioFuente);hold on;
subplot(3,2,4);plot(t,p_p,colorc);grid on;title('$\dot{\delta_t}$','Interpreter','latex','FontSize',TamanioFuente);hold on;
subplot(3,1,3);plot(t,u,colorc);grid on;title('Acción de control','FontSize',TamanioFuente);xlabel('Tiempo en Seg.','FontSize',TamanioFuente);hold on;
