clear
clc

%% Controller parameters

load('linssmodel.mat')
X00   = X0;
Cbar  = diag([1 1 1]); % Outputs to be controlled
C     = Cbar*C_new;
p     =  12;
m     =  6;
Ref   = [0.03 0.25 375]';
% Qy    = eye(3);
Qy    = diag([10000000 10000000 1]);
Qu    = eye(2);
Ymeas=[2;2;200]
Xkk  = X0;
%% State estimator parameters

R     = eye(3,3)*0.01;
P00   = 100*[0.001 0.003 0.003 0.003;
           0.003 0.003 0.003 0.003;
           0.003 0.003 0.003 2] ;
Q     = 0.1*diag([1 1 1]);


