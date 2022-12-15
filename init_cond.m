%Initial conditi
close all
clc

%% GET INITIAL STATE VECTOR
%%ORIGINAL AIRFOIL: CST coeff
load("orig.mat")

%% OPTIMIZE TO FIND SUITABLE CST
%%AIRFOIL
figure(1)
hold on
axis equal

airfoilPoints = 15;
airfoilStep = 0.5/airfoilPoints;

options = optimoptions("fminunc");
options.MaxFunctionEvaluations = 1e6;

CSTextra = fminunc(@(x) CSTerror(x,whitcomb_extra),[1,1,1,1,1,1],options);
C = Cnm(0.5,1);
S = Sa(CSTextra);
Fextra = @(x) C(x).*S(x);
x_airfoil = (1-sin(pi*(0:airfoilStep:0.5)))';
y_airfoil = Fextra(x_airfoil);

CSTintra = fminunc(@(x) CSTerror(x,whitcomb_intra),[1,1,1,1,1,1],options);
C = Cnm(0.5,1);
S = Sa(CSTintra);
Fintra = @(x) C(x).*S(x);
x_airfoil = [x_airfoil;(1-sin(pi*(0.5+airfoilStep:airfoilStep:1)))'];
y_airfoil = [y_airfoil;Fintra((1-sin(pi*(0.5+airfoilStep:airfoilStep:1)))')];

p=ezplot(Fextra,[0,1]);
p.LineWidth = 1.5;
p.Color = "red";
p=ezplot(Fintra,[0,1]);
p.LineWidth = 1.5;
p.Color = "red";

scatter(whitcomb_intra(:,1),whitcomb_intra(:,2),50,"blue","X","LineWidth",1)
scatter(whitcomb_extra(:,1),whitcomb_extra(:,2),50,"blue","X","LineWidth",1)
ylim([-0.2,0.2])
xlabel("")
title("Original Point Cloud vs. CST Parametrization")

%FORMATO Q3D
CST_A = [CSTextra,CSTintra];
CST_B = [CSTextra,CSTintra];
CST_C = [CSTextra,CSTintra];

%FORMATO EMWET
writematrix([x_airfoil,y_airfoil],"AIRFOIL_A.dat",'Delimiter','tab')
writematrix([x_airfoil,y_airfoil],"AIRFOIL_B.dat",'Delimiter','tab')
writematrix([x_airfoil,y_airfoil],"AIRFOIL_C.dat",'Delimiter','tab')

%% Values from reference aircraft
y.croot_0  = 6.4823; %[m]
y.taper1_0 = 0.6596;
y.taper2_0 = 0.3983;
y.b2_0     = 11.5252; %[m]
y.sweep2_0 = 27.8572; %[deg]
y.twist1_0 = -5;%[deg]
y.twist2_0 = -3;%[deg]
sweep1     = 20;
y.CST1_0   = CST_A;
y.CST2_0   = CST_B;
y.CST3_0   = CST_C;

%%Q3D LOADS:
%CMA calculation
CMA1    = 2/3*y.croot_0*((y.taper1_0+1)/(y.taper1_0^2+y.taper1_0+1));
c_kink  = y.taper1_0*y.croot_0;
CMA2    = 2/3*c_kink*((y.taper2_0+1)/(y.taper2_0^2+y.taper2_0+1));
b1      = 3.162;
S1      = (y.croot_0+c_kink)*b1/2;
c_tip   = y.croot_0*y.taper2_0*y.taper1_0;
S2      = (c_kink+c_tip)*y.b2_0/2;
CMA     = CMA1*S1/(S1+S2)+CMA2*S2/(S1+S2);

%CL calculation
g      = 9.81;
Wtomax = 79000; %[kg]
n      = 2.5;
L      = n*Wtomax*g;

%Flight conditions for Q3d inviscid
fc.V     = 201.662;            % flight speed (m/s)
fc.rho   = 0.3804;         % air density  (kg/m3)
fc.alt   = 10668;             % flight altitude (m)
fc.visc  = 0;
visc     = 8.9E-6;
fc.Re    = fc.V*fc.rho*CMA/visc;        % reynolds number (bqased on mean aerodynamic chord)
fc.M     = 0.84;           % flight Mach number 
fc.CL    = L/(1/2*fc.rho*(fc.V^2)*2*(S1+S2)); %2*(S1+S2), S1+S2 es la superficie alar de un semiala

cd 'Q3D'
Res=Q3D_Start_V1(y,fc,b1,sweep1);
cd '..'

cl  = Res.Wing.ccl;
cm  = Res.Wing.cm_c4;
yst = Res.Wing.Yst;
w.b1  = b1;
w.b2  = y.b2_0;
w.yst = linspace(0,1,20);
q     = 1/2*fc.rho*fc.V^2;
w.ccl  = interp1(yst,cl*q,w.yst*(w.b1+w.b2),'spline')
w.cm_c4= interp1(yst,cm*q*CMA,w.yst*(w.b1+w.b2),'spline')

%%EMWET:
%Initial files
par.namefile    =    'B737-800.init';
par.MTOW        =    Wtomax;         %[kg]
par.MZF         =    61690;         %[kg]
par.nz_max      =    2.5;   
par.b1          =    b1;
par.b2          =    y.b2_0;       %[m]
par.root_chord  =    y.croot_0;       %[m]
par.taper1      =    y.taper1_0;    
par.taper2      =    y.taper2_0;
par.sweep1      =    sweep1;      %[deg]
par.sweep2      =    y.sweep2_0;      %[deg]
par.spar_front  =    0.2;
par.spar_rear   =    0.8;
par.ftank_start =    0;
par.ftank_end   =    0.85;
par.eng_num     =    1;
par.eng_ypos    =    0.25;
par.eng_mass    =    1200;         %kg
par.E_al        =    7.1E10;       %N/m2
par.rho_al      =    2800;         %kg/m3
par.Ft_al       =    2.95E8;       %N/m2
par.Fc_al       =    2.95E8;       %N/m2
par.pitch_rib   =    0.5;          %[m]
par.eff_factor  =    0.93;         %Depend on the stringer type
par.Airfoil_root=    'AIRFOIL_root';
par.Airfoil_kink=    'AIRFOIL_kink';
par.Airfoil_out =    'AIRFOIL_out';
par.section_num =    3;
par.airfoil_num =    3;
par.wing_surf   =    S1+S2;

file1=write_init(par)

%%Loads file:
w.namefile=('B737-800.load')
file2=write_loads(w)

EMWET('B737-800')

wing_weight=read_output()

y.E_0=16;
fuel_weight=breguett(y.E_0,fc.V,Wtomax) %El fuel weight sale en kg

%%Q3D (Get Drag for A-W)
%Flight conditions for Q3d
L        = sqrt(Wtomax*(Wtomax-fuel_weight))*g; %[N]
%Flight conditions for Q3d
fc.V     = 234;            % flight speed (m/s)
fc.rho   = 0.3804;         % air density  (kg/m3)
fc.alt   = 10668;             % flight altitude (m)
fc.visc  = 1;
visc     = 8.9E-6;
fc.Re    = fc.V*fc.rho*CMA/visc;        % reynolds number (bqased on mean aerodynamic chord)
fc.M     = 0.789*0+0.7;           % flight Mach number 
fc.CL    = L/(1/2*fc.rho*(fc.V^2)*2*(S1+S2)); %2*(S1+S2), S1+S2 es la superficie alar de un semiala

cd 'Q3D'
Res2=Q3D_Start_V1(y,fc,b1,sweep1);
cd '..'

%% Cálculo CDa-w
Cd_aw_0=(Res2.CLwing/y.E_0)-Res2.CDwing;        %E = Cl/(Cd+Cd_aw_0*S_0/S)

