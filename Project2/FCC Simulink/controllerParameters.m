%% Controller parameters
p     =  7;
m     =  3;
% Qy    = eye(3);
Qy    = diag([10000000 10000000 1]);
Qu    = eye(2);
 
load('linssmodel.mat')
Cbar  = diag([1 1 1]); % Outputs to be controlled
C     = Cbar*C_new;
Ref   = [0.03 0.25 375]';
Y0    = C*X0; % initial measurement