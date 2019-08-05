function  uStar = inputPlan(A,B,C,X0,Yref,Qu,Qy,Ymeas,flag, p,m)
 
%{
A,B,C  - State space model matrices
X0     - Current estimated state
Yref   - Reference measurement for the prediction horizon size Nxp 
N      - number of measurements
L      - number of inputs
p      - Prediction horizon
m      - control horizon
Qu     - input weights
Qy     - measurement weights
%}

[n, L] = size(B);
[N,~]=size(C);

% construct the input variables 
u = sym('u', [L m]);
u=[u u(:,end)*ones(1,p-m)];

% Obtain measurement estimates for in terms of the input variables
Yhat=sym('Yhat',[N p]);
for i=1:p
    Yhat(:,i)=C*A^i*X0;
    for l=1:i
        Yhat(:,i)=Yhat(:,i)+C*A^(i-l)*B*u(:,l);
    end 
end

if flag==1
   Yhat(:,1)=Yhat(:,1)+C*(Ymeas-C*X0)'; 
end

% Cost function
Jmeas=0;
for i=1:p
    Jmeas=Jmeas+transpose(Yref(:,i)-Yhat(:,i))*Qy*(Yref(:,i)-Yhat(:,i));
end
Jinput=0;
for i=1:m
    Jinput = Jinput + transpose(u(:,i))*Qu*u(:,i);
end

J = Jmeas+Jinput;
fprintf('Objective function formulated.\n')
fprintf('Minimizing objective function...\n')
% Jout = matlabFunction(J,'vars', {u},'file','mpcObj.m')
Jout = matlabFunction(J,'vars', {u});
% uStar = fminunc(Jout,zeros(L,m));
 
options = optimset('PlotFcns',@optimplotfval);
uStar = fminunc(Jout,zeros(L,m),options);
% uStar = fminsearch(Jout,zeros(L,m),options);
uStar = [uStar uStar(:,end)*ones(1,p-m)];

end


 
