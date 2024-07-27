 clear all;
 
 %Defining variables as global variables, so they can be directly used inside any external function
 global delT; %sample time
 global Iteration;
 
 global Iz Iw g M Lf Lr d Af ro Ap ;
 global W Ldr Ldf theta_f theta_r ;
 global Cf Cr;    %Front and rear cornerinf stiffness estimates

 
 d  = 0.73 ;            %Wheel diameter(m)   225/60 R18
 Af = 2.0;              %Frontal area
 ro = 1.225;             %Air density
 Ap = 6;                %Plan area
 Iz = 3484;             %Moment of inertia of car around yaw axis
 Iw = 0.225;            %Moment of inertia wheel around rotating axis 
 g  = 9.81;             %Gravitational constant
 M  = 1673;             %Overall vehicle mass with the driver
 Lf = 0.91;             %Distance to front axle from CG
 Lr = 1.73;             %Distance to rear axle from CG
 L = Lf+Lr;
 W = 1.585;             %Track width
 Ldr = sqrt(Lr^2+(W/2)^2);  %distance from CG to center of a rear wheel
 Ldf = sqrt(Lf^2+(W/2)^2);  %distance from CG to center of a front wheel
 theta_f = atand((W/2)/Lf);
 theta_r = atand((W/2)/Lr);

 %%%Maximum correction values 

 yaw_rate_error_max = 0.227;  %global maximum for all scenarios considered here
 
 corr_steer_max = 3; %degrees
 corr_torq_max = (90000)*Lf*deg2rad(corr_steer_max)/(2*W/d);   %equvalent max torque to the torque from max steering input
 
 
 %Defining arrays to save output parameter values during entire lap time
 YArray = zeros(1,2);       %array to store all the arrays created by each time step
 Y = zeros(1,2);            %array of varaibles for ode solve
 Time = zeros();            %array to store time stamps of all the ode solve steps
 YPrev = [0 0];             %initial value array which is updated by final values of previous ode solution
 DELTA = zeros();
 VEL = zeros();
 GAMMA_DES = zeros();
 BETA_DES = zeros();
 yaw_errors = zeros();

 Iteration = 0;

 V = 16.667*100/60; % m/s (100 km/h)  %set velocity in m/s
 %V = 16.667; % m/s (60 km/h)
 Delta = 10;
 Nz = 0;
 
delT = 0.05;
n = 105;
%omega = 0.5;
omega = 2*pi*0.2;

pre_gamma_des = 0;
pre_beta_des = 0;
pre_beta = 0;
xi = 0.5;
K = 20;
del = 0.01;


cor_steer = 0;
corr_torq = 0;
corr_TV_gain = 0;           % set value between 0 and 1 (1 for max TV level and 0 for no TV)
TVp = corr_TV_gain*100;
corr_AS_gain = 0;           % set value between 0 and 1 (1 for max AS level and 0 for no AS)
ASp = corr_AS_gain*100;

for i = 1:n    
     display(i);
        
     Delta = 10*sin(omega*Time(end));  %steer amplitude 10 degrees
     Delta_corr = Delta + cor_steer;
     
     [T,Y] = solve(YPrev,V,Delta_corr,Nz); %Solving the ode set     

     beta = Y(end,1);
     gamma = Y(end,2);
     
     K_us = M*(Lr/Cf - Lf/Cr)/(2*(Lf+Lr));          %Understeer factor
     gamma_des = V*deg2rad(Delta)/(Lf+Lr+K_us*V^2); %Desired yaw rate
     %beta_des = ( Lr - (Lf*M*V^2)/(2*Cr*(Lf+Lr)) )*deg2rad(Delta)/(Lf+Lr+K_us*V^2);   
     
    %%%%%% Corrective torque based on fuzzy cotroller %%%%

    fis = readfis('Fuzzy Logic Controller_AS_TV');  %read fuzzy file
 
    yaw_rate_error = gamma_des-gamma ;
    yaw_rate_error_norm = yaw_rate_error/yaw_rate_error_max;    %normalized yaw rate error 

    corrections = evalfis(fis,yaw_rate_error_norm);             %calculating corrective actions through fis
    cor_whl_torq_l = corr_torq_max*corrections(1);
    cor_whl_torq_r = corr_torq_max*corrections(2);
    cor_steer = corr_AS_gain*corr_steer_max*corrections(3);     %corrective steering 
    corr_torq = (cor_whl_torq_r/(d/2)-cor_whl_torq_l/(d/2))*(W/2); 
  
    Nz = corr_TV_gain*corr_torq ;                              %corrective torque
     
     YPrev = Y(end,:);%Equating the simulation end values as the initial values for next step

     %Filling the arrays to plot the graphs
     YArray = cat(1, YArray, Y);
     Time = cat(1,Time,T+Time(end));
     DELTA = cat(1,DELTA,Delta_corr*ones(size(T,1),1));
     VEL = cat(1,VEL,V*ones(size(T,1),1));
     GAMMA_DES = cat(1,GAMMA_DES,gamma_des*ones(size(T,1),1));
     yaw_errors = cat(1,yaw_errors,yaw_rate_error*ones(size(T,1),1));
end 

fprintf("max yaw error: %g", max(yaw_errors));
fprintf("\nmin yaw error: %g", min(yaw_errors));

% Calculate the percentage errors
relative_yaw_errors = (YArray(:,2) - GAMMA_DES) .^ 2;

% Calculate the mean of the squared percentage errors
meanPercentageError = mean(relative_yaw_errors);

% Calculate the root of the mean error as a percentage
rmse = sqrt(meanPercentageError)/max(GAMMA_DES) * 100;

fprintf("\nRMSP yaw error: %g %", rmse);
 

% figure
% plot(Time,yaw_errors,'-r')%Yaw rate errors
% title("Yaw Rate error vs Time")
% hold off;

% figure
% plot(Time,YArray(:,2),'-b')%Yaw Rate
% hold on;
% plot(Time,YArray(:,1),'-r')%Body Slip Angle
% title("Yaw Rate(blue) and Body Slip angle(red) vs Time")
% hold off;

% figure
% plot(Time,VEL,'-g')%Long Velocity

figure
hold on;
plot(Time,DELTA,'color',[0.7 0 0.5],'linewidth',1) %Steering angle
title("Steering Angle vs time")
hold off;

plot(Time,YArray(:,2),'-b') %Yaw Rate
hold on;
plot(Time,GAMMA_DES,'-r')   %Desired Yaw Rate
xlim([0 5.05]);
ylim([-1.8 1.8]);
titlestr = sprintf('TV: %.2f %% AS: %.2f %%', TVp, ASp);
title(titlestr);
xlabel('Time (s)')
ylabel('Yaw rate (rad/s)')
leg = legend("Yaw Rate","Desired Yaw Rate",'Location','southwest');
dim = [.55 .5 .3 .3];
str = sprintf('RMSE: %.2f\\%%', rmse);
annotation('textbox', dim, 'String', str, 'FitBoxToText', 'on','EdgeColor', 'none','Interpreter', 'latex');
hold off;


