%Initial conditi
close all
clc

%% GET INITIAL STATE VECTOR
%%ORIGINAL AIRFOIL: CST coeff
load("orig.mat")

%% OPTIMIZE TO FIND SUITABLE CST
%%ROOT AIRFOIL
figure(1)
hold on
axis equal

airfoilPoints = 15;
airfoilStep = 0.5/airfoilPoints;

options = optimoptions("fminunc");
options.MaxFunctionEvaluations = 1e6;

CSTextra = fminunc(@(x) CSTerror(x,orig_extra_root),[1,0.5,1,1,1,1,1,1],options);
C = Cnm(CSTextra(1),CSTextra(2));
S = Sa(CSTextra(3:end));
Fextra = @(x) C(x).*S(x);
x_airfoil = (1-sin(pi*(0:airfoilStep:0.5)))';
y_airfoil = Fextra(x_airfoil);

CSTintra = fminunc(@(x) CSTerror(x,orig_intra_root),[1,0.5,1,1,1,1,1,1],options);
C = Cnm(CSTintra(1),CSTintra(2));
S = Sa(CSTintra(3:end));
Fintra = @(x) C(x).*S(x);
x_airfoil = [x_airfoil;(1-sin(pi*(0.5+airfoilStep:airfoilStep:1)))'];
y_airfoil = [y_airfoil;Fintra((1-sin(pi*(0.5+airfoilStep:airfoilStep:1)))')];

p=ezplot(Fextra,[0,1]);
p.LineWidth = 1.5;
p.Color = "red";
p=ezplot(Fintra,[0,1]);
p.LineWidth = 1.5;
p.Color = "red";

scatter(orig_intra_root(:,1),orig_intra_root(:,2),50,"blue","X","LineWidth",1)
scatter(orig_extra_root(:,1),orig_extra_root(:,2),50,"blue","X","LineWidth",1)
ylim([-0.2,0.2])
xlabel("")
title("Original Point Cloud vs. CST Parametrization")

%FORMATO Q3D ROOT
CST_root = [CSTextra,CSTintra]

%FORMATO EMWET ROOT
writematrix([x_airfoil,y_airfoil],"AIRFOIL_root.dat",'Delimiter','tab')

%%TIP AIRFOIL
figure(2)
hold on
axis equal

CSTextra = fminunc(@(x) CSTerror(x,orig_extra_out),[1,0.5,1,1,1,1,1,1],options);
C = Cnm(CSTextra(1),CSTextra(2));
S = Sa(CSTextra(3:end));
Fextra = @(x) C(x).*S(x);
x_airfoil = (1-sin(pi*(0:airfoilStep:0.5)))';
y_airfoil = Fextra(x_airfoil);

CSTintra = fminunc(@(x) CSTerror(x,orig_intra_out),[1,0.5,1,1,1,1,1,1],options);
C = Cnm(CSTintra(1),CSTintra(2));
S = Sa(CSTintra(3:end));
Fintra = @(x) C(x).*S(x);
x_airfoil = [x_airfoil;(1-sin(pi*(0.5+airfoilStep:airfoilStep:1)))'];
y_airfoil = [y_airfoil;Fintra((1-sin(pi*(0.5+airfoilStep:airfoilStep:1)))')];

p=ezplot(Fextra,[0,1]);
p.LineWidth = 1.5;
p.Color = "red";
p=ezplot(Fintra,[0,1]);
p.LineWidth = 1.5;
p.Color = "red";

scatter(orig_intra_out(:,1),orig_intra_out(:,2),50,"blue","X","LineWidth",1)
scatter(orig_extra_out(:,1),orig_extra_out(:,2),50,"blue","X","LineWidth",1)
ylim([-0.2,0.2])
xlabel("")
title("Original Point Cloud vs. CST Parametrization")

%FORMATO Q3D TIP
CST_out = [CSTextra,CSTintra];

%FORMATO EMWET TIP
writematrix([x_airfoil,y_airfoil],"AIRFOIL_out.dat",'Delimiter','tab')

%%KINK AIRFOIL
figure(3)
hold on
axis equal
%FORMATO Q3D KINK
CST_kink = (CST_out+CST_root)/2;

CSTextra = CST_kink(1:size(CST_kink,2)/2);
C = Cnm(CSTextra(1),CSTextra(2));
S = Sa(CSTextra(3:end));
Fextra = @(x) C(x).*S(x);
x_airfoil = (1-sin(pi*(0:airfoilStep:0.5)))';
y_airfoil = Fextra(x_airfoil);

CSTintra = CST_kink(size(CST_kink,2)/2+1:end);
C = Cnm(CSTintra(1),CSTintra(2));
S = Sa(CSTintra(3:end));
Fintra = @(x) C(x).*S(x);
x_airfoil = [x_airfoil;(1-sin(pi*(0.5+airfoilStep:airfoilStep:1)))'];
y_airfoil = [y_airfoil;Fintra((1-sin(pi*(0.5+airfoilStep:airfoilStep:1)))')];

p=ezplot(Fextra,[0,1]);
p.LineWidth = 1.5;
p.Color = "red";
p=ezplot(Fintra,[0,1]);
p.LineWidth = 1.5;
p.Color = "red";

scatter(x_airfoil,y_airfoil,50,"blue","X","LineWidth",1)
ylim([-0.2,0.2])
xlabel("")
title("Original Point Cloud vs. CST Parametrization")

%FORMATO EMWET KINK
writematrix([x_airfoil,y_airfoil],"AIRFOIL_kink.dat",'Delimiter','tab')

%% Values from reference aircraft
y.croot_0  = 6.4823; %[m]
y.taper1_0 = 0.6596;
y.taper2_0 = 0.3983;
y.b2_0     = 11.5252; %[m]
y.sweep2_0 = 27.8572; %[deg]
y.twist1_0 = 10;%[deg]
y.twist2_0 = 10;%[deg]
sweep1     = 27.8572;
y.CST1_0   = CST_root;
y.CST2_0   = CST_kink;
y.CST3_0   = CST_out;

%%Q3D LOADS:
%CMA calculation
CMA1    = 2/3*y.croot_0*((y.taper1_0+1)/(y.taper1_0^2+y.taper1_0+1));
croot_1 = y.taper1_0*y.croot_0;
CMA2    = 2/3*croot_1*((y.taper2_0+1)/(y.taper2_0^2+y.taper2_0+1));
b1      = 3.162;
S1      = (y.croot_0+croot_1)*b1/2;
croot_2 = croot_1*y.taper2_0;
S2      = (croot_1+croot_2)*y.b2_0/2;
CMA     = CMA1*S1/(S1+S2)+CMA2*S2/(S1+S2);

%CL calculation
g=9.81;
Wtomax=79000*g; %[N]
n=2.5;
L=n*Wtomax;

%Flight conditions for Q3d
fc.V     = 262.7;            % flight speed (m/s)
fc.rho   = 0.3804;         % air density  (kg/m3)
fc.alt   = 10668;             % flight altitude (m)
visc     = 8.9E-6;
fc.Re    = fc.V*fc.rho*CMA/visc;        % reynolds number (bqased on mean aerodynamic chord)
fc.M     = 0.785;           % flight Mach number 
fc.CL    = L/(1/2*fc.rho*fc.V^2*(S1+S2));   

cd 'Q3D'
Res=Q3D_Start_V1(y,fc,b1,sweep1);
cd '..'

w.cl=Res.Wing.cl;
w.cm=Res.Wing.cm_c4;
w.yst=Res.Wing.Yst;

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
par.taper2      =    y.taper2_0
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
par.Airfoil_root     =    'AIRFOIL_root';
par.Airfoil_kink     =    'AIRFOIL_kink';
par.Airfoil_out     =    'AIRFOIL_out';
par.section_num =    3;
par.airfoil_num =    3;
par.wing_surf   =    S1+S2;

file1=write_init(par)

%%Loads file:
w.namefile=('B737-800.load')
file2=write_loads(w)

EMWET('B737-800')