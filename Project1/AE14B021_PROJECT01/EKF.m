clear
clc

%%
load('DATA_REQD_2.mat')

Y0_0   = [2; 2 ; 150];      % initial guess for state
% P0_0   = 10000*diag([1 1 1]);
P0_0   = 1*[0.001 0.003 0.003; 0.003 0.003 0.003; 0.003 0.003 2] ;
Q      = 0.1*diag([1 1 1]);
 

%% 
prompt   = 'Enter 0 for case 1 and 1 for case 2\n';
flag     = input(prompt);

if flag==0
    ymeas = Y_measured_case1;
    Cc     =[ 0 0 1];
else
    ymeas = Y_measured_case2;
    Cc    = [1 0 0; 0 0 1];
end

R      = std(ymeas);
R      = (diag(R))^2;
n      = max(size(ymeas)); 
Y      = [];   % states 
Ts     = Time(2)-Time(1);
u      = InputU;
s      = size(P0_0);
tspan  = [0 Ts];              % [startTime endTime]
t      = Time;

for k=1:n
    
    ymeas1=ymeas(k,:);   %  supply new measurement
    uk   = (u(k,:))';    %  control input

    [A,B,C,D]=modelLinearizer(t,Y0_0,uk,Ts,Cc,0);  % obtain linearized model
    fprintf('Step %d model linearized \n', k)
    
    % Prediction
    fun=@(t,y)yrates(t,y,uk);
    [tout, yout]    = ode45(fun, tspan, Y0_0, 0.00000001);
    Y1_0 = (yout(end,:))';   % predicted estimated
    P1_0=A*P0_0*A'+Q;

    % Correction
    K=P1_0*C'*inv(C*P1_0*C'+R);        % Optimal Kalman gain
    Y0_0=Y1_0+K*(ymeas1'-C*Y1_0-D*uk);  
    Y=[Y Y0_0];
    P0_0=(eye(s)-K*C)*P1_0;
    fprintf('Step %d complete \n', k)
end 

sprintf('Max errors are %d and %d',max(ymeas(:,1)-Y(1,:)'),max(ymeas(:,2)-Y(3,:)'))
% 
% for k=1:3
% subplot(4,1,k)
% plot(Y(k,:),'o')
% end
% subplot(4,1,4)
% plot(ymeas,'x')