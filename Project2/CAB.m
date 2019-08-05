function CABi=CAB(A,B,C,i,m)

[t,~] = size(C);
[~,s]=size(B);
CABi = [];
if ge(m,i)
 for k=1:i
   CABi = [C*A^(k-1)*B; CABi];
 end
 CABi = [ CABi; zeros((m-i)*t,s)];
else
    for k=1:m-1
    CABi = [C*A^(k-1)*B; CABi];
    end
    At =0;
    for j=1:i-m
       At = At+C*A^j*B; 
    end
    CABi = [CABi ; At];
end