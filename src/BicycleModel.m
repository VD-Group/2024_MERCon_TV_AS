function dydt = BicycleModel(t,y,v,Delta,Nz, varargin)

        global Iz Iw g M Lf Lr d Af ro Ap ; % refer VDCOM2 for meaning of these variables
        global W Ldr Ldf theta_f theta_r ;
        
        %Fzf = M*g/4000; %Vertical tire load
        Fzf = (Lr/(Lr+Lf))*M*g/2000;
        Fzr = (Lf/(Lr+Lf))*M*g/2000;
        Fr = 0.01*Fzf*1000;%Rolling resistance
     
        global Cf Cr;    %Front and rear cornerinf stiffness estimates
        global Cx; 
        gamma = 1;        %Camber angle 


        %----------------------------Defining Lateral Tire Coefficients------------------------------------------
        %--------------------------------------------------------------------------------------------------------
        a0= 1.29;
        a = [(0.18) (-0.9) -12.95 1.72 0.22 0.68 -1.07 -0.003 0.0035 0.045 -0.03 0.045 -0.45 -0.174 -4.5 -12.35 -0.63 ];


        %Coefficient for front wheels
        H = a(8)*Fzf + a(9) + a(10)*gamma;
        D =  Fzf*(a(1)*Fzf + a(2))*(1 - a(15)*(gamma^2));
        C = a0;
        BCD = a(3)*sind(2*atand(Fzf/a(4)))*(1-a(5)*abs(gamma));
        B = BCD/(C*D);
        E = (a(6)*Fzf + a(7))*(1-(a(16)*gamma + a(17))*sign(1));
        V1 = a(11)*Fzf + a(12) + (a(13)*Fzf + a(14))*gamma*Fzf;
        
        %Coefficient for rear wheels
        H2 = a(8)*Fzr + a(9) + a(10)*gamma;
        D2 =  Fzr*(a(1)*Fzr + a(2))*(1 - a(15)*(gamma^2));
        C2 = a0;
        BCD2 = a(3)*sind(2*atand(Fzr/a(4)))*(1-a(5)*abs(gamma));
        B2 = BCD2/(C2*D2);
        E2 = (a(6)*Fzr + a(7))*(1-(a(16)*gamma + a(17))*sign(1));
        V2 = a(11)*Fzr + a(12) + (a(13)*Fzr + a(14))*gamma*Fzr;        
        

        %Fy = D*sind(C*atand(B*x - E*(B*x - atand(B*x)))) + V;   
        
        %----------------------------Defining Longitudinal Tire Coefficients------------------------------------------
        %-------------------------------------------------------------------------------------------------------------
        b0 = 1.62;
        b = [-0.0487 (1.035) -0.13 19.4 -0.171 -0.063 -0.122 0.5 8.42E-5 -0.0005 0 0 0];
        
        H1 =  b(9)*Fzr +b(10);
        D1 =  Fzr*(b(1)*Fzr + b(2));
        C1 = b0;
        BCD1 = (b(3)*(Fzr^2)+b(4)*Fzr)*exp(-b(5)*Fzr);
        B1 = BCD1/(C1*D1);
        %E1 = (b(6)*Fzr^2 + b(7)*Fzr+b(8))*(1- b(13)*sign(1));
        V1 = b(11)*Fzr + b(12);
        %Fx = D1*sind(C1*atand(B1*x - E1*(B1*x - atand(B1*x)))) + V1; 
        
        dydt = zeros(2,1);
        
        %///////////////////////////////////////////////////////////////////////////////////////////
%         Cx =  (2/3)*BCD1*100;
%         Cf =  (2/3)*BCD*180/pi; %N/rad
%         Cr =  (2/3)*BCD2*180/pi; %N/rad
        
        Cf =  90000; %N/rad
        Cr =  55000; %N/rad

        a_11 = -2*(Cf + Cr)/(M*v);        
        a_12 = -2*((Cf*Lf - Cr*Lr)/(M*v^2)) - 1;        
        a_21 = -2*(Cf*Lf - Cr*Lr)/Iz;
        a_22 = -2*(Cf*Lf^2 + Cr*Lr^2)/(Iz*v);
        b_11 = 2*Cf/(M*v) ;
        b_12 = 0;
        b_21 = 2*Cf*Lf/Iz ;
        b_22 = 1/Iz ;
        
        A_1 = [a_11 a_12 ; a_21 a_22];
        B_1 = [b_11 b_12 ; b_21 b_22];
        %display(eig(A_1));
        dydt = A_1*[y(1);y(2)] + B_1*[ deg2rad(Delta) ; Nz ] ;        

end 
