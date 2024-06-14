clear all;close all;
ii=0;TitaRef=pi/2;T=1.1e-3;
% T=0;
Ts=0.001;Veces_Euler=1e2;t_etapa=Ts/Veces_Euler;tF=.6;
Laa= 2.3870e-04; J=4.2578e-10;Ra=25.3177;Bm=0;Ki=0.0021;Km=0.0605;
Mat_Ac=[-Ra/Laa -Km/Laa 0; Ki/J -Bm/J 0; 0 1 0];
Mat_Bc=[1/Laa; 0; 0];Mat_Fc=[0;-1/J;0];
Mat_C=[0 0 1];
H=[0;0;0];F=H;d_tao=Ts/100;tao=0;
for hh=1:100
 dF=expm(Mat_Ac*tao)*Mat_Fc*d_tao;
 F=F+dF;
 dH=expm(Mat_Ac*tao)*Mat_Bc*d_tao;
 H=H+dH;
 tao=tao+d_tao;
end
Mat_B=H;
Mat_F=F;
Mat_A=expm(Mat_Ac*Ts);eig(Mat_A)
Mat_Aa=[Mat_A zeros(3,1);-Mat_C*Mat_A, 1];
Mat_Ba=[Mat_B;-Mat_C*Mat_B];
Q=diag([1e0 1e-3 1e1 1e5]);
R=1e3; %Nótese con R=1 no cumple restricciones de u
%Contrucción del Hamiltoniano para el cálculo del controlador
H=[Mat_Aa -Mat_Ba*inv(R)*Mat_Ba'; -Q -Mat_Aa'];
[V,D]=eig(H);MX1X2=[];
for ii=1:8
 if real(D(ii,ii))<1
 MX1X2=[MX1X2 V(:,ii)];
 end
end
MX1=MX1X2(1:4,1:4); MX2=MX1X2(5:8,1:4);
P=real(MX2*inv(MX1));
Ka=inv(R+Mat_Ba'*P*Mat_Ba)*Mat_Ba'*P*Mat_Aa;
aut_controlador=abs(eig(Mat_Aa-Mat_Ba*Ka));
Mat_A_O=Mat_A';Mat_B_O=Mat_C';Qo=diag([1e-1 1e-2 1e0]);Ro=1e-1;
%Contrucción del Hamiltoniano para el cálculo del controlador
Ho=[Mat_A_O -Mat_B_O*inv(Ro)*Mat_B_O'; -Qo -Mat_A_O'];
[Vo,Do]=eig(Ho);MX1X2=[];
for ii=1:6
 if real(Do(ii,ii))<1
 MX1X2=[MX1X2 Vo(:,ii)];
 end
end
MX1o=MX1X2(1:3,1:3); MX2o=MX1X2(4:6,1:3);
Po=real(MX2o*inv(MX1o));
Ko=(inv(Ro+Mat_B_O'*Po*Mat_B_O)*Mat_B_O'*Po*Mat_A_O)';
eig(Mat_A-Ko*Mat_C)
x_hat=[0;0;0];x=[0;0;0];zona_m=1;ve1(1)=pi/2;t=0;y_hat=0;
for ii=0:1:tF/t_etapa
 t(ii+1)=t_etapa*ii;
 y=Mat_C*x;
 ve1(ii+2)=ve1(ii+1)+TitaRef-y;
 u(ii+1)=-Ka*[x_hat;ve1(ii+1)];
 if(abs(u(ii+1))<zona_m)
 u(ii+1) = 0;
 else
 u(ii+1) = sign(u(ii+1))*(abs(u(ii+1)-zona_m));
 end
 if u(ii+1)>24
 u(ii+1)=24;
 end
 if u(ii+1)<-24
 u(ii+1)=-24;
 end
 x=Mat_A*x+Mat_B*u(ii+1)+Mat_F*T;
 x_hat=Mat_A*x_hat+Mat_B*u(ii+1)+Ko*(y-y_hat)+Mat_F*T;
 y_hat=Mat_C*x_hat;
 Ia(ii+1)=x(1); %Ia
 Omega(ii+1)=x(2); %omega
 Tita(ii+1)=x(3); %tita
 if t(ii+1)>0.3
 TitaRef=-pi/2;
 T=0;
 end
end

subplot(4,1,1);plot(t,Ia,'r');title('Ia_t');hold on;grid on;
subplot(4,1,2);plot(t,Omega,'b');title('\omega');xlabel('Tiempo [Seg.]');hold on;grid on;
subplot(4,1,3);plot(t,Tita,'c');title('\theta_t');hold on;grid on;
subplot(4,1,4);plot(t,u,'y');title('u_t');hold on;grid on;
