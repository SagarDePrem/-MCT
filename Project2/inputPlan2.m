function uStar = inputPlan2(A,B,C,Xkk,Yref,Qu,Qy,Ymeas,flag, p,m)

%{
A,B,C  - State space model matrices
Xkk    - Current estimated state
Yref   - Reference measurement for the prediction horizon size Nxp 
N      - number of measurements
L      - number of inputs
p      - Prediction horizon
m      - control horizon
Qu     - input weights
Qy     - measurement weights
%}

[n, L] = size(B);
[N,~]  = size(C);
H      = 0 ;
f      = 0 ; 

for i = 1:p
    CABj = CABhoriz(A,B,C,i,m);
    H = H + CABj'*Qy*CABj;
    f = f + Xkk'*(A^i)'*C'*Qy*CABj -Yref(:,i)'*Qy*CABj;
end

QuBlock = Qu;
for  b = 1:m-1
    QuBlock = blkdiag(QuBlock,Qu);
end
H = H+QuBlock; 
uStar = quadprog(H,f);
uStar = reshape(uStar,L,[]);
uStar = [uStar uStar(:,end)*ones(1,p-m)];
end
