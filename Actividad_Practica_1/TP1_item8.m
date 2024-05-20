clear all;clc;
i=1;t_etapa=1e-6;TitaRef=pi/2;tF=0.9;
Torque=1.15e-3;t=0:t_etapa:tF;
Laa=366e-6; J=5e-9;Ra=55.6;B=0;Ki=6.49e-3;Km=6.53e-3;
u=linspace(0,0,tF/t_etapa+1);ia=linspace(0,0,tF/t_etapa);
u_O=u;
omega=linspace(0,0,tF/t_etapa);tita=linspace(0,0,tF/t_etapa);
tita(1)=pi/2;
Mat_A=[-Ra/Laa -Km/Laa 0; Ki/J -B/J 0; 0 1 0];
Mat_B=[1/Laa; 0; 0];
%Mat_B=[1/Laa 0; 0 1/J; 0 0];
Mat_C=[0 0 1];
eig(Mat_A)
Mat_M=[Mat_B Mat_A*Mat_B Mat_A^2*Mat_B ];%Matriz Controlabilidad
%Cálculo del controlador por asignación de polos
auto_val=eig(Mat_A)
c_ai=conv(conv([1 -auto_val(1)],[1 -auto_val(2)]),[1 -auto_val(3)]);
Mat_W=[c_ai(3) c_ai(2) 1;c_ai(2) 1 0;1 0 0];
Mat_T=Mat_M*Mat_W;
A_controlable=inv(Mat_T)*Mat_A*Mat_T %Verificación de que T esté bien
%CONTROLADOR Ubicación de los polos de lazo cerrado en mui:
mui(1)=-.5e2;mui(2)=-5e2+0.5i; mui(3)=conj(mui(2));
alfa_i=conv(conv([1 -mui(3)],[1 -mui(2)]),[1 -mui(1)]);
K=fliplr(alfa_i(2:4)-c_ai(2:4))*inv(Mat_T);
eig(Mat_A-Mat_B*K)
Mat_A_O=Mat_A';
Mat_B_O=Mat_C';
Mat_M_Dual=[Mat_B_O Mat_A_O*Mat_B_O Mat_A_O^2*Mat_B_O];%Matriz Controlabilidad
alfaO_i=alfa_i;
% Ubicacion del Observador
% Algunas veces más rápido que el controlador
mui_o=real(mui)*20;
alfaO_i=conv(conv([1 -mui_o(3)],[1 -mui_o(2)]),[1 -mui_o(1)]);
Mat_T_O=Mat_M_Dual*Mat_W;
Ko=(fliplr(alfaO_i(2:end)-c_ai(2:end))*inv(Mat_T_O))';
eig(Mat_A_O'-Ko*Mat_C) %Verifico que todos los polos estén en el semiplano izquierdo
Gj=-inv(Mat_C*inv(Mat_A-Mat_B*K)*Mat_B);
x_hat=[0;0;0]; %Inicializo el Observador
x_op=[0 0 0]';
while(i<(tF/t_etapa))
estado=[ia(i);omega(i);tita(i)];
u(i)=-K*(estado-x_op)+Gj*TitaRef; color_='b'; %Sin Observador
u_O(i)=-K*(x_hat-x_op)+Gj*TitaRef; color_='r'; %Con Observador
    if u(i)>12
%         u(i)=12;
    end

    if u(i)<-12
%         u(i)=-12;
    end
wp = ia(i)*(Ki/J) - omega(i)*(B/J) - Torque/J;
iap = -ia(i)*(Ra/Laa) - omega(i)*(Km/Laa) + u(i)/Laa;
omega(i+1) = omega(i) + t_etapa*wp;
ia(i+1) = ia(i) +t_etapa*iap;
tita(i+1) = tita(i) + t_etapa*omega(i);
    if i*t_etapa>0.3
        TitaRef=-pi/2;
        Torque=0;
    end
    if i*t_etapa>0.6
        TitaRef=pi/2;
        Torque=1.15e-3;
    end
acc(i+1)=u(i);
acc2(i+1)=u_O(i);
y_sal(i)=Mat_C*estado;
%________OBSERVADOR__________
y_sal_O(i)=Mat_C*x_hat;
y_sal(i)=Mat_C*estado;
x_hatp=Mat_A*(x_hat-x_op)+Mat_B*u(i)+Ko*(y_sal(i)-y_sal_O(i));
x_hat=x_hat+t_etapa*x_hatp;
i=i+1;
%     psi_p=TitaRef-X(3); %ERROR
%     psi(ii+2)=psi(ii+1)+psi_p*h;
%     u(ii+1)=-K*X+KI*psi(ii+1);
end
subplot(4,1,1);hold on;
plot(t,ia,color_);title('corriente ia_t');
subplot(4,1,2);hold on;
plot(t,tita,color_);title('Salida Y, tita_t');
subplot(4,1,3);hold on;
plot(t,omega,color_);title('Omega');
xlabel('Tiempo [Seg.]');
subplot(4,1,4);hold on;
plot(t,acc,color_);hold on;plot(t,acc2); title('Entrada u_t, v_a');