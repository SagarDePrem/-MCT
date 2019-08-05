clc
clear

%% System definition

[A,B,C,D] = 
Q     = 0.001;  % variance in equation
R     = 0.1;    % variance in measurement
X0_0  = 0;      % initial guess for state
P0_0  = 1000;   
Y     = [0.9  0.8 1.1 1 0.95 1.05 1.2 0.9 0.85 1.15] ;
X     = X0_0;
s     = size(P0_0);
n     = max(size(Y));

%% Kalman filter

for k=1:n
    Y1=Y(k);   
  
    % Prediction
    X1_0=A*X0_0;
    P1_0=A*P0_0*A'+Q;

    % Correction
    K=P1_0*C'*inv(C*P1_0*C'+R);        % Optimal Kalman gain
    X0_0=X1_0+K*(Y1-C*X1_0);
    X=[X ; X0_0];
    P0_0=(eye(s)-K*C)*P1_0;
    
end 
X