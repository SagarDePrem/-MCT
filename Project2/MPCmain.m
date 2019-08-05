clear
clc
%%
load('linssmodel.mat')

Cbar  = diag([1 1 1]); % Outputs to be controlled
C     = Cbar*C_new;
p     =  12;
m     =  6;
Ref   = [0.03 0.25 375]';
% Qy    = eye(3);
Qy    = diag([10000000 10000000 1]);
Qu    = eye(2);



Yref=[];
for i=1:p
Yref=[Yref Ref];
end

% prompt = 'Enter 1/0 to include disturbance or not (part e)\n';
% flag   = input(prompt);

flag   = 0;
Ymeas  = [2 ; 0.0001;  390];

% uStar =inputPlan(A,B,C,X0,Yref,Qu,Qy,Ymeas,flag, p,m);
uStar =inputPlan2(A,B,C,X0,Yref,Qu,Qy,Ymeas,flag, p,m);

figure
[k,~] = size(uStar);
for i=1:k
    subplot(k,1,i)
    stairs(uStar(k,:))
    str = sprintf('u_%d', i);
    title(str)
end
    

