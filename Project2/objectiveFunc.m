function Jout = objectiveFunc(A,B,C,X0,Yref,Qu,Qy,p,m)

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

[N, L] =size(B);

% construct the input variables 
u = sym('u', [L m]);
for i=m+1:p
    u=[u u(:,m)];
end

% Obtain measurement estimates for in terms of the input variables
Yhat=sym('Yhat',[N p])
for i=1:p
    Yhat(:,i)=C*A^i*X0;
    for l=1:i
        Yhat(:,i)=Yhat(:,i)+C*A^(i-l)*B*u(:,l);
    end 
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
Jout = matlabFunction(J,'vars', {u});
end


 
