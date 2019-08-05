clear
clc
%% Model parameters

global A B C Ts X0 Nstate Noutput Ninput   
load('linssmodel.mat')
Cbar  = diag([1 1 1]); % Outputs to be controlled
C     = Cbar*C_new;
[Noutput,Nstate] = size(C);
[~,Ninput] = size(B) ;
  
%% Controller parameters

global p m  Qy Qu
p     =  7;
m     =  3;
% Qy    = eye(3);
Qy    = diag([10000000000 100000 10000]);
Qu    = diag([500 300]);

%% Input profile

Ref   = [0.03 0.25 375]';
Y0    = C*X0; % initial measurement
Yref=[];

for i=1:p
Yref=[Yref; Ref];
end

%% Kalman filter parameters

global Q R 
Q      = eye(Nstate)*0.01;
R      = diag([1 2 10])*0.001;
P00    = [3 3 3 3; 3 3 3 3; 3 3 3 3; 3 3 3 3]*10000;