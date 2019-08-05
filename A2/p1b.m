%% case 1
A=[-2 2; 2 -2];
B=[1 0;0 -1];
Ts=01;
Ad=expm(A*Ts) 
% Bd=inv(A'*A)*A'*(expm(A*Ts)-eye)*B
% C=[Ad*Bd Bd];
% rank(C)