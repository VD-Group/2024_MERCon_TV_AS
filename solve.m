function [T,Y] = solve(Y,V,Delta,Nz)
     global delT;
     tspan = linspace(0,delT,10); % Defining the time span -> Start time,End time,number of steps
     [T,Y] = ode45(@(t,x) BicycleModel(t,x,V,Delta,Nz),tspan,Y); %Solving the set of 1st order diff equations
 
     %[T,Y] = ode45(@(t,x) MotorSISO(t,x,u,J,Kt,L,Kb,R),tspan,x);
end

