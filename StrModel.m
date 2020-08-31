function [u1,ud1,udd1,kk]=StrModel(f,u,ud,udd,kk)

% kk=kk+1;
disp(kk)
dt_s=0.01; %time step from newmark integration (Structural solver)
% u=0.2;
% u_temp=0.2;
% if t1==1.001
%     u=u_temp;
% else
%     u;
% end
%Parameters
beta=1/6;
gamma=1/2;
m=15000;%1dof properties m=23,55[kg],k=262.24[N/m],c=[(N-s)/m]
k=135000;
zeta=0.005; % 0.5% zeta 
omega=3;
c=2*m*omega*zeta;
% udd=(-k*0.2)/m;
a1=1/(beta.*dt_s^2).*m+gamma./(beta.*dt_s).*c;
a2=1/(beta.*dt_s).*m+(gamma./beta-1).*c;
a3=(1/(2.*beta)-1).*m+dt_s.*(gamma./(2.*beta)-1).*c;
kbar=k+a1;
fbar=f+a1.*u+a2.*ud+a3.*udd; %+m*ag - for ground acceleration
u1=fbar./kbar;
ud1=gamma./(beta.*dt_s).*(u1-u)+(1-gamma./beta).*ud+dt_s.*(1-gamma./(2.*beta)).*udd;
udd1=1./(beta.*dt_s.^2)*(u1-u)-1./(beta.*dt_s).*ud-(1./(2.*beta)-1)*udd;
end
