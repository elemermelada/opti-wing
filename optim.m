function [f]=optim(x, W_aw, CD_aw)

y.croot  = x(1); %[m]
y.taper1 = x(2);
y.taper2 = x(3);
y.b2     = x(4); %[m]
y.sweep2 = x(5); %[deg]
y.twist1 = x(6);%[deg]
y.twist2 = x(7);%[deg]

i=1;
while i<13
    y.CST1(i)  = x(8+i-1);
    y.CST2(i)  = x(20+i-1);
    y.CST3(i)  = x(32+i-1);
    i=i+1;
end

y.Wwing_c = x(44);
y.E_c     = x(45);
y.Wfuel_c = x(46);

id='A';
CST=[y.CST1(1:6), y.CST1(7:12)];
[CST_A]=writexy(CST,id)
id='B'
CST=[y.CST2(1:6), y.CST2(7:12)];
[CST_B]=writexy(CST,id)
id='C'
CST=[y.CST3(1:6), y.CST3(7:12)];
[CST_C]=writexy(CST,id)

%%Llamada a las disciplinas
%Q3D Loads:
Wtomax = W_aw + y.Wwing_c + y.Wfuel_c; %[kg]
g      = 9.81;
n      = 2.5;
L      = n*Wtomax*g;
ca = 0; %Evaluate Q3D inviscid
[Res0, CMA, S]=Q3Dinit(y,b1,sweep1, L, ca)

%EMWET:
[Wwing]=EMWETinit(Res0, y, b1, sweep1, CMA, S, Wtomax)
y.Wwing = Wwing;

%Q3D AERO
L  = sqrt(Wtomax*(Wtomax-y.Wfuel_c))*g; %[N]
ca = 1; %Evaluate Q3D viscous
[Res1]=Q3Dinit(y,b1,sweep1, L, ca)
y.E = Res2.CLwing / (Res2.CDwing + Cd_aw/(S));

%Breguett:
y.Wfuel = breguett(y.E_c,249.1192,(W_aw+y.Wwing_c+y.Wfuel_c)) %El fuel weight sale en kg

f = W_aw + y.Wwing + y.Wfuel;

end
