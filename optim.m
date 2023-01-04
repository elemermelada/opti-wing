function [fad]=optim(x)

global parameters;
Cd_aw=parameters.Cd_aw;
W_aw=parameters.W_aw;
W_tomax_0=parameters.Wtomax_0;

global initial;
croot_0=initial.croot;
taper1_0=initial.taper1;
taper2_0=initial.taper2;
b2_0=initial.b2;
sweep2_0=initial.sweep2;
twist1_0=initial.twist1;
twist2_0=initial.twist2;
CST1_0=initial.CSTr;
CST2_0=initial.CSTk;
CST3_0=initial.CSTt;
Wwing_0=initial.Wwing_0;
E_0=initial.E_0;
Wfuel_0=initial.Wfuel_0;

%El vector de diseño x es adimensional, lo dimensionalizamos

y.croot  = x(1)*croot_0; %[m]
y.taper1 = x(2);
y.taper2 = x(3);
y.b2     = x(4)*b2_0; %[m]
y.sweep2 = x(5)*sweep2_0; %[deg]
y.twist1 = x(6)*twist1_0;%[deg]
y.twist2 = x(7)*twist2_0;%[deg]

y.CST1 = x(8:19);
y.CST3 = x(20:31);
y.CST2 = (x(8:19)+x(20:31))./2;
y.Wwing_c = x(end-2)*Wwing_0;
y.E_c     = x(end-1)*E_0;
y.Wfuel_c = x(end)*Wfuel_0;

id='A';
CST=[y.CST1(1:6), y.CST1(7:12)];
[CST_A]=writexy(CST,id);
id='B'
CST=[y.CST2(1:6), y.CST2(7:12)];
[CST_B]=writexy(CST,id);
id='C'
CST=[y.CST3(1:6), y.CST3(7:12)];
[CST_C]=writexy(CST,id);

%%Llamada a las disciplinas
%Q3D Loads:
Wtomax = W_aw + y.Wwing_c + y.Wfuel_c; %[kg]
g      = 9.81;
n      = 2.5;
L      = n*Wtomax*g;
ca = 0; %Evaluate Q3D inviscid
[Res0, CMA, S]=Q3Dinit(y,parameters.b1,parameters.sweep1, L, ca);

%EMWET:
MZFW = Wtomax - y.Wfuel_c;
[Wwing]=EMWETinit(Res0, y, parameters.b1, parameters.sweep1, CMA, S, Wtomax, MZFW);
y.Wwing = Wwing;

%Q3D AERO
L  = sqrt(Wtomax*(Wtomax-y.Wfuel_c))*g; %[N]
ca = 1; %Evaluate Q3D viscous
[Res1]=Q3Dinit(y,parameters.b1,parameters.sweep1, L, ca);
y.E = Res1.CLwing / (Res1.CDwing + Cd_aw/(S));

%Breguett:
y.Wfuel = breguett(y.E_c,249.1192,(W_aw+y.Wwing_c+y.Wfuel_c)); %El fuel weight sale en kg

f = W_aw + y.Wwing + y.Wfuel;

%Definition of the extra design variables as global variables:
global couplings;
vararg={y.Wwing,y.E,y.Wfuel,y.Wwing_c,y.E_c,y.Wfuel_c};
couplings.y.Wwing=y.Wwing;
couplings.y.E=y.E;
couplings.y.Wfuel=y.Wfuel;

fad=f/W_tomax_0;
end
