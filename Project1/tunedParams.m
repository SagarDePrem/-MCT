
% Y0_0   = [10; 10 ; 100000];      % initial guess for state
% % P0_0   = 10000*diag([1 1 1]);
% P0_0   = 100*[0.004 0.003 0.003; 0.003 0.003 0.003; 0.003 0.003 200] ;
% Q      = 0.04*diag([1 1 1]);

plot(Y(2,:),'red')
 
hold on
% plot(ymeas(4:end),'blue')
title('Estimated O_{d}')
ylabel('O_{d}')
xlabel('Time step')