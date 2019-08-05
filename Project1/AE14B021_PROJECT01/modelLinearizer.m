function [A,B,C,D]=modelLinearizer(t,y,u,Ts,Cc,Dc)

fun=@(Y)yrates(t,Y,u);
[Ac,~]=jacobianest(fun, y);
% Ac=numeric_jacobian(fun, y);

fun=@(u)yrates(t,y,u);
[Bc,~]=jacobianest(fun, u);
% Bc=numeric_jacobian(fun, u);

sys=ss(Ac,Bc,Cc,Dc);
sys= c2d(sys,Ts);
[A, B, C, D] = ssdata(sys);

end