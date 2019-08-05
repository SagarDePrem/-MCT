clear
clc
%% Model parameters

global A B C Ts X0 Nstate Noutput Ninput p m  Qy Qu Profile 
load('linssmodel.mat')
Cbar             = diag([1 1 1]); % Outputs to be controlled
C                = Cbar*C_new;
[Noutput,Nstate] = size(C);
[~,Ninput]       = size(B) ;
Y0               = diag([5 2 0.85])*C_new*X0; % initial measurement
% Y0               = [ 0.019 0.2 600]'; 
%% Input prompt

prompt = {
          sprintf('Set point options\n 1 - Constant profile\n 2 - Non constant profile') ,...
          'Constant Reference', ...
          sprintf('Noise options\n 1 - no noise\n 2 - Gaussian noise\n 3 - bias'), ...
          'Variance for Gaussian noise','Bias','m - Control horizon  ', ...
          'p - Prediction horizon', ...
          'Simulation steps', 'Qy', 'Qu'...
          'Q' , 'R', 'P00'
         };
defaultans={
              '1','[0.03 ;0.25; 375]','1','[0.00001 0.0001 0.15]', ...
              '[-0.001; 0.004 ; 0.003]',...
              '3','7','500', ...
             '[4 5 5]','[0.05 0.05]', ...
             '[1 1 1 1]*0.001', '[1 2 10]*10'...
             '[3 3 3 3; 3 3 3 3; 3 3 3 3; 3 3 3 3]*10000'
            };
        
size    = [1 50; 1 50 ; 1 50; 1 50; 1 50; 1 50; ...
           1 50; 1 50; 1 50; 1 50; 1 50;  1 50; 1 50  ];
ui   = inputdlg(prompt,'Input', size, defaultans );

flag1 = str2num(ui{3});
m     = str2num(ui{6});
p     = str2num(ui{7}); 
nsteps = str2num(ui{8});
Qy    = diag(str2num(ui{9}));
Qu    = diag(str2num(ui{10}));

%% Plant data

b        = str2num(ui{5}); ;
sigma    =diag(str2num(ui{4}));

%% Set point profile

Ref = str2num(ui{2}); 
Profile = Ref ;
flag = str2num(ui{1});
if flag == 1
   for i=1:10100
   Profile=[Profile Ref];
   end
elseif flag == 2 
   for i=1:70000
   Profile=[diag([1.00001 0.99999 0.99999])*Profile Ref];
   end
else 
    fprintf ('Error! Case not found!')
end

%% Kalman filter parameters

global Q R 
Q      = diag(str2num(ui{11})) ;
R      = diag(str2num(ui{12})) ;
P00    = str2num(ui{13});