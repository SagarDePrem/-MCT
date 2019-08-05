function phi=phi(theta,M)
f=@(x)shockAngle(x,theta,M)
phi=[fmincon(f,0.1);fmincon(f,pi/2)] 
end
