% Add path to APM libraries
addpath('apm');

% Clear MATLAB
clear all
close all

% Select server
server = 'http://byu.apmonitor.com';

% Application
app = 'nlc';

% Clear previous application
apm(server,app,'clear all');

% load model variables and equations
apm_load(server,app,'cstr.apm');

% load data
csv_load(server,app,'cstr.csv');

% Set up variable classifications for data flow

% Feedforwards - measured process disturbances
apm_info(server,app,'FV','Caf');
apm_info(server,app,'FV','Tf');
% Manipulated variables (for controller design)
apm_info(server,app,'MV','tc');
% State variables (for display only)
apm_info(server,app,'SV','Ca');
% Controlled variables (for controller design)
apm_info(server,app,'CV','T');

% imode = 1, steady state mode
apm_option(server,app,'nlc.imode',1);
% solve here for steady state initialization
apm(server,app,'solve')

% imode = 7, switch to sequential simulation
apm_option(server,app,'nlc.imode',7);
% nodes = 3, internal nodes in the collocation structure (2-6)
apm_option(server,app,'nlc.nodes',3);
% simulation step size for every 'solve' command
apm_option(server,app,'nlc.ctrl_time',0.25);
% coldstart application
apm_option(server,app,'nlc.coldstart',1);
% read csv file
apm_option(server,app,'nlc.csv_read',1);

% Run APMonitor
apm(server,app,'solve')

% Retrieve solution (creates solution.csv locally)
solution = apm_sol(server,app);
% Extract names
names = solution(1,:);
% Extract values
cc = cell2mat(solution(2:end,:));

% Time is always the first column or row
time_apm = cc(:,1);

% extract 'Ca'
index = find(strcmpi('Ca',names));
Ca_apm = cc(:,index);

% extract 'T'
index = find(strcmpi('T',names));
T_apm = cc(:,index);

% extract 'Tc'
index = find(strcmpi('Tc',names));
Tc_apm = cc(:,index);

% ---------------------------------------------------------
% simulate with ode15s (for comparison)
% Verify dynamic response of CSTR model

global u

% Steady State Initial Conditions for the States
Ca_ss = 0.989;
T_ss = 296.6;
Tc_ss = 270;
y_ss = [Ca_ss;T_ss];

% Open Loop Step Change
u = 271;

% Final Time (sec)
tf = 5;

[t_ode15s,y] = ode15s('cstr1',[0.25 tf],y_ss);

% Parse out the state values
Ca_ode15s = y(:,1);
T_ode15s = y(:,2);
% ---------------------------------------------------------

%%
% linearized model

Cooling_Temp = Tc_ss;  % Temperature of cooling jacket (K)
Flow = 100;            % Volumetric Flowrate (m^3/sec)
V = 100;               % Volume of CSTR (m^3)
rho = 1000;            % Density of A-B Mixture (kg/m^3)
Cp = .239;             % Heat capacity of A-B Mixture (J/kg-K)
mdelH = 5e4;           % Heat of reaction for A->B (J/mol)
                       % E - Activation energy in the 
                       %  Arrhenius Equation (J/mol)
                       % R - Universal Gas Constant 
                       %  = 8.31451 J/mol-K
EoverR = 8750;         % EoverR = E/R
k0 = 7.2e10;           % Pre-exponential factor (1/sec)
                       % U - Overall Heat Transfer 
                       %  Coefficient (W/m^2-K)
                       % A - Area - this value is specific
                       %  for the U calculation (m^2)
                       % UA = U * A
UA = 5e4;
Feed_Conc = 1;         % Feed Concentration (mol/m^3)
Feed_Temp = 350;       % Feed Temperature (K)

Concentration = Ca_ss; % Concentration of A in CSTR (mol/m^3)
Ca = Concentration;
Temperature  = T_ss;   % Temperature in CSTR (K)
T = Temperature;

k = k0*exp(-EoverR/T);
rate = k * Ca;

% State Space Model
% dx/dt = A * x + B * u
%     y = C * x + D * u
A = [(-Flow/V-k)          -k*EoverR/T^2;
     (mdelH*k/(rho*Cp))   (-Flow/V-UA/(rho*Cp*V) + mdelH*k/(rho*Cp)*EoverR/T^2)];
B = [(Flow/V)     0       0;
        0      Flow/V  UA/(rho*Cp*V)];
C = [1 0; 0 1];
D = zeros(2,3);
sys = ss(A,B,C,D);

[y_lin,t_lin] = step(sys);
Ca_lin = y_lin(:,1,3) + Ca_ss;
T_lin = y_lin(:,2,3) + T_ss;

% add 0.25 sec delay
t_lin = [0;0.25;t_lin+0.25];
Ca_lin = [Ca_ss;Ca_ss;Ca_lin];
T_lin = [T_ss;T_ss;T_lin];

%%
% Trending
figure(1)
subplot(3,1,1);
plot(time_apm,Ca_apm,'b-');
hold on;
plot(t_ode15s,Ca_ode15s,'k--')
plot(t_lin,Ca_lin,'r-.');
xlabel('Time (min)')
ylabel('Concentration')
legend('APM','ODE15s','Linear');

subplot(3,1,2);
plot(time_apm,T_apm,'b-');
hold on;
plot(t_ode15s,T_ode15s,'k--');
plot(t_lin,T_lin,'r-.');
ylabel('Temp (K)');
legend('APM','ODE15s','Linear');

subplot(3,1,3);
plot(time_apm,Tc_apm,'g-');
xlabel('Time (min)');
ylabel('Temp (K)');
legend('Jacket');