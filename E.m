function [Eout] = E(x,Wto_max,E)
%E Summary of this function goes here
%   Detailed explanation goes here

%% Constant params
rho = 1.225;
V = 452*1.852;      %ref speed in km/s
R = 2897*1.852;     %ref range in km
Ct = 1.8639e-4;     %ref ct in 1/s (TODO - change to 2186.84kg/h)

%% Geometry (to be derived from x) (TODO - actually derive from x)
% x y z chord(m) twist angle (deg)
AC.Wing.Geom = [0 0 0 3.5 0;
0.9 14.5 0 1.4 0];
% Wing incidence angle (degree)
AC.Wing.inc = 0;
% Airfoil coefficients input matrix
% | -> upper curve coeff. <-| | -> lower curve coeff. <-|
AC.Wing.Airfoils =[0.2171 0.3450 0.2975 0.2685 0.2893 -0.1299 -0.2388 -0.1635 -0.0476 0.0797;
0.2171 0.3450 0.2975 0.2685 0.2893 -0.1299 -0.2388 -0.1635 -0.0476 0.0797];
AC.Wing.eta = [0;1]; % Spanwise location of the airfoil sections
S = 100; % TODO - obtain S from x

%% Flow settings (to remain constant)
AC.Visc = 1; % 0 for inviscid and 1 for viscous analysis
AC.Aero.V = 68; % flight speed (m/s)
AC.Aero.rho = 1.225; % air density (kg/m3)
AC.Aero.alt = 0; % flight altitude (m)
AC.Aero.Re = 1.14e7; % reynolds number (bqased on mean aerodynamic chord)
AC.Aero.M = 0.2; % flight Mach number

%% CL value from Ldes
Wfuel = (1-0.938*exp(-R*Ct/V/E))*Wto_max;
Ldes = sqrt(Wto_max*(Wto_max-Wfuel));
CL = 2*Ldes/rho/V^2/S
AC.Aero.CL = CL; % lift coefficient - comment this line to run the code for given alpha%
AC.Aero.MaxIterIndex = 150;
% AC.Aero.Alpha = alpha; % angle of attack - comment this line to run the code for given cl

%% SOLUTION
cd Q3D
Res = Q3D_solver(AC);
cd ..
Eout = Res.CLwing/Res.CDwing;

end

