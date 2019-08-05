clear
clc
close  
%%
SystemParams
uk       = [ 0; 0];
Xkk      = X0 ;
meas     = [];
Pkk      = P00;
estState = []; 
Yk       = Y0;
% Yk       = [0.028; 0.24; 380]; 

time     = [] ;
% nsteps   = 1950;
input    = [];
b        = [-0.001; 0.004 ; 0.003];
sigma    =diag([0.001 0.001 1.5]);
% global  noise
noise = 0;

for k= 1: nsteps
    
    %% Plant  - measurement generator 
    tspan = [Ts*(k-1) Ts*k] ;   
    fun=@(t,y)yrates(t,y,uk);
    [tout, yout]    = ode45(fun, tspan, Yk-noise, 0.00001);
    if flag1 == 1
        noise =0;
    elseif flag1 == 2 
        noise =  sigma*randn(Noutput,1);
    elseif flag1 == 3
        noise = b;
    end
    Yk1 = (yout(end,:))'+ noise;
    meas = [meas Yk1];
    fprintf(sprintf('Measurement obtained at step %d\n',k))
    
    %% State estimator - Kalman filter
    [Xk1k1,Pk1k1] = KalmanFilter(Yk1,uk,Xkk,Pkk);
    estState = [estState Xk1k1];
    fprintf(sprintf('State estimated at step %d\n',k)) 
    
    %% Controller - Model Predictive controller
    Yref = Profile(:,k:k+p);
    uk1 = Controller(Yref,Xk1k1);
    input = [input  uk1]; 
    fprintf(sprintf('Control input given at step %d\n',k))
        
     %%  step k is over, reset
    
    uk = uk1;
    Xkk = Xk1k1;
    Pkk = Pk1k1;
    Yk  = Yk1;
    time = [time Ts*k];
    
end

 

figure
plot(time, meas(1,:),'red')
hold on
plot(time, Profile(1,1:nsteps), 'blue')
xlabel('Time (s)')
ylabel('C_{rc} ')
legend('Measurement','Set point profile')

figure
plot(time, meas(2,:),'red')
hold on
plot(time, Profile(2,1:nsteps), 'blue')
xlabel('Time (s)')
ylabel('O_{d} ')
legend('Measurement','Set point profile')

figure
plot(time, meas(3,:),'red')
hold on
plot(time, Profile(3,1:nsteps), 'blue')
xlabel('Time (s)')
ylabel('T_{rg} ')
legend('Measurement','Set point profile')

figure
subplot(2,1,1)
stairs(time, input(1,:),'red')
ylabel('u_1')
subplot(2,1,2)
stairs(time, input(2,:), 'blue')
xlabel('Time (s)')
ylabel('u_2')
