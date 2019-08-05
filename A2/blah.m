A=[-2 2; 2 -2];
B=[1 0 ; 0 -1];
sys=ss(A,B,[1  1],[0])
sysd=c2d(sys,1)