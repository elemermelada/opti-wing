%Initial conditi
% close all
% clc
function [y, Cd_aw_0, W_aw, Wtomax_0, S, b1, sweep1]=init_cond()
%% GET INITIAL STATE VECTOR
%%ORIGINAL AIRFOIL: CST coeff
load("orig.mat")

%% OPTIMIZE TO FIND SUITABLE CST
%%AIRFOIL

options = optimoptions("fminunc");
options.MaxFunctionEvaluations = 1e6;

CSTextra = fminunc(@(x) CSTerror(x,whitcomb_extra),[1,1,1,1,1,1],options);
CSTintra = fminunc(@(x) CSTerror(x,whitcomb_intra),[1,1,1,1,1,1],options);

id='A';
CST=[CSTextra, CSTintra];
[CST_A]=writexy(CST,id)
id='B'
[CST_B]=writexy(CST,id)
id='C'
[CST_C]=writexy(CST,id)


%% Values from reference aircraft
sweep1     = 34.9089;
b1         = 3.162;
y.croot    = 6.4823; %[m]
y.taper1    = 0.6596;
y.taper2   = 0.3983;
y.b2       = 11.5252; %[m]
y.sweep2   = 27.8572; %[deg]
y.twist1   = 0;%[deg]
y.twist2   = 0;%[deg]
y.CST1     = CST_A;
y.CST2     = CST_B;
y.CST3     = CST_C;

%%Q3D iniviscid
Wtomax_0 = 79000; %[kg]
g      = 9.81;
n      = 2.5;
L      = n*Wtomax_0*g;
ca = 0; %Evaluate Q3D inviscid
[Res0, CMA, S]=Q3Dinit(y,b1,sweep1, L, ca)

%%EMWET:
[Wwing_0]=EMWETinit(Res0, y, b1, sweep1, CMA, S, Wtomax_0)
y.Wwing_0 = Wwing_0;

%%Breguett:
y.E_0       = 16;
fuel_weight = breguett(16,249.1192,Wtomax_0) %El fuel weight sale en kg
y.Wfuel_0   = fuel_weight;

%%Q3D (Get Drag for A-W)
%Flight conditions for Q3d
L        = sqrt(Wtomax_0*(Wtomax_0-fuel_weight))*g; %[N]
ca = 1; %Evaluate Q3D viscous
[Res1]=Q3Dinit(y,b1,sweep1, L, ca)

%% Cálculo CDa-w
Cd_aw_0=((Res0.CLwing/y.E_0)-Res1.CDwing)*(S);        %E = Cl/(Cd+Cd_aw_0*S_0/S)

W_aw = Wtomax_0 - y.Wwing_0 - y.Wfuel_0;
end