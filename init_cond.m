%Initial conditions
clear
close all
clc

%% GET INITIAL STATE VECTOR
%%ORIGINAL AIRFOIL: CST coeff
load("orig.mat")

%%OPTIMIZE TO FIND SUITABLE CST
options = optimoptions("fminunc");
options.MaxFunctionEvaluations = 1e6;
CSTextra = fminunc(@(x) CSTerror(x,orig_extra),[1,0.5,1,1,1,1,1,1],options);
C = Cnm(CSTextra(1),CSTextra(2));
S = Sa(CSTextra(3:end));
Fextra = @(x) C(x).*S(x);

CSTintra = fminunc(@(x) CSTerror(x,orig_intra),[1,0.5,1,1,1,1,1,1],options);
C = Cnm(CSTintra(1),CSTintra(2));
S = Sa(CSTintra(3:end));
Fintra = @(x) C(x).*S(x);

%%ACTUALLY PLOT EVERYTHING
figure(1)
hold on
axis equal

p=ezplot(Fextra,[0,1])
p.LineWidth = 1.5;
p.Color = "red";
p=ezplot(Fintra,[0,1]);
p.LineWidth = 1.5;
p.Color = "red";

scatter(orig_intra(:,1),orig_intra(:,2),50,"blue","X","LineWidth",1)
scatter(orig_extra(:,1),orig_extra(:,2),50,"blue","X","LineWidth",1)
ylim([-0.2,0.2])
xlabel("")
title("Original Point Cloud vs. CST Parametrization")

%%Values from reference aircraft
x.croot_0  = 6.4823; %[m]
x.taper1_0 = 0.8;
x.taper2_0 = 0.6;
x.b2_0     = 11.5252; %[m]
x.sweep2_0 = 27.8572; %[deg]
x.twist1_0 = 10;%[deg]
x.twist2_0 = 10;%[deg]
sweep1     = 27.8572;
x.CST1_0   = CSTextra;
x.CST2_0   = CSTintra;

%%Q3D LOADS:
%CMA calculation
CMA1    = 2/3*x.croot_0*((x.taper1_0+1)/(x.taper1_0^2+x.taper1_0+1));
croot_1 = x.taper1_0*x.croot_0;
CMA2    = 2/3*croot_1*((x.taper2_0+1)/(x.taper2_0^2+x.taper2_0+1));
b1      = 3.162;
S1      = (x.croot_0+croot_1)*b1/2;
croot_2 = croot_1*x.taper2_0;
S2      = (croot_1+croot_2)*b1/2;
CMA     = CMA1*S1/(S1+S2)+CMA2*S2/(S1+S2);

%CL calculation
g=9.81;
Wtomax=78245*g; %[N]
n=2.5;
L=n*Wtomax;

%Flight conditions for Q3d
fc.V     = 262.7;            % flight speed (m/s)
fc.rho   = 0.3804;         % air density  (kg/m3)
fc.alt   = 10668;             % flight altitude (m)
visc     = 8.9*10^-6;
fc.Re    = fc.V*fc.rho*CMA/visc;        % reynolds number (bqased on mean aerodynamic chord)
fc.M     = 0.785;           % flight Mach number 
fc.CL    = L/(1/2*fc.rho*fc.V^2*(S1+S2));   

cd 'Q3D'
Res=Q3D_Start_V1(x,fc,b1,sweep1);
cd '..'
