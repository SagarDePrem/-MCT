function Fout = KalmanFilter(Fin)

filterParameters

tspan         = [0 Ts];              % [startTime endTime]    
Ymeas         = Fin(1:Noutput);
uk            = Fin(Noutput+1:Noutput+Ninput);
Xkk           = Fin(Noutput+Ninput+1:Noutput+Ninput+Nstate);
Pkk           = reshape(Fin(Noutput+Nstate+Ninput+1:end),Nstate,[]);

% Prediction

fun          = @(t,y)yrates(t,y,uk);
[tout, yout] = ode45(fun, tspan, Xkk, 0.00000001);
Xk1k         = (yout(end,:))';   % predicted estimated
Pk1k         = A*Pkk*A'+Q;
     
% Correction

K            = Pk1k*C'*inv(C*Pk1k*C'+R);        % Optimal Kalman gain
Xk1k1        = Xk1k+K*(Ymeas-C*Xk1k); 
Pk1k1        = (eye(Nstate)-K*C)*Pk1k;

Fout    = [Xk1k1; reshape(Pk1k1,[],1)];

