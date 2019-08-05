%% Kalman filter parameters

t      = 0;
load('linssmodel.mat')
Cbar  = diag([1 1 1]); % Outputs to be controlled
C     = Cbar*C_new;
[Noutput,Nstate] = size(C);
Ninput = 2 ;
Q      = eye(Nstate)*0.01;
R      = eye(Noutput)*0.001;
P00    = [3 3 3 3; 3 3 3 3; 3 3 3 3; 3 3 3 3];

% Fin = [2; 2; 200; 1 ;1; X0; 3;3;3;3; 3;3;3;3; 3;3;3;3;  3;3;3;3]
