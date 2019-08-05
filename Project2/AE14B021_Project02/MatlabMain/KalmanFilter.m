function [Xk1k1,Pk1k1] = KalmanFilter(Yk1,uk,Xkk,Pkk)

global A B C Nstate Noutput Ninput Q R noise
% filterParameters

% Ymeas         = Fin(1:Noutput);
% uk            = Fin(Noutput+1:Noutput+Ninput);
% Xkk           = Fin(Noutput+Ninput+1:Noutput+Ninput+Nstate);
% Pkk           = reshape(Fin(Noutput+Nstate+Ninput+1:end),Nstate,[]);


% Prediction

    Xk1k   = A*Xkk+B*uk;
    Pk1k   = A*Pkk*A'+Q;
     
% Correction

K            = Pk1k*C'*inv(C*Pk1k*C'+R);        % Optimal Kalman gain
Xk1k1        = Xk1k+K*(Yk1-C*Xk1k); 
Pk1k1        = (eye(Nstate)-K*C)*Pk1k;

% Fout    = [Xk1k1; reshape(Pk1k1,[],1)];


