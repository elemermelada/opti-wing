%% Aerodynamic solver setting
function [Res]=Q3D_Start_V1(x,fc,b1,sweep1)
% Wing planform geometry 
%                x    y     z   chord(m)    twist angle (deg) 
AC.Wing.Geom = [0     0     0     x.croot_0         x.twist1_0;
                (tand(sweep1)*b1)  b1   0     (x.croot_0*x.taper1_0)        ((x.twist1_0+x.twist2_0)/2);
                (tand(sweep1)*b1+tand(x.sweep2_0)*x.b2_0)  (x.b2_0+b1)   0   (x.croot_0*x.taper2_0*x.taper1_0)  x.twist2_0];

% Wing incidence angle (degree)
AC.Wing.inc  = 0;   
            
            
% Airfoil coefficients input matrix
%                    | ->     upper curve coeff.                <-|   | ->       lower curve coeff.       <-| 
AC.Wing.Airfoils   = [x.CST1_0;
                     x.CST2_0;
                     x.CST3_0];


% TODO - Remove this
AC.Wing.Airfoils   = [0.2171    0.3450    0.2975    0.2685    0.2893  -0.1299   -0.2388   -0.1635   -0.0476    0.0797;
                     0.2171    0.3450    0.2975    0.2685    0.2893  -0.1299   -0.2388   -0.1635   -0.0476    0.0797;
                     0.2171    0.3450    0.2975    0.2685    0.2893  -0.1299   -0.2388   -0.1635   -0.0476    0.0797];
                  
AC.Wing.eta = [0; (b1/(b1+x.b2_0)); 1];  % Spanwise location of the airfoil sections

% Viscous vs inviscid
AC.Visc  = fc.visc;              % 0 for inviscid and 1 for viscous analysis
AC.Aero.MaxIterIndex = 1500;    %Maximum number of Iteration for the
                                %convergence of viscous calculation
                                
                                
% Flight Condition
AC.Aero.V     = fc.V;            % flight speed (m/s)
AC.Aero.rho   = fc.rho;         % air density  (kg/m3)
AC.Aero.alt   = fc.alt;             % flight altitude (m)
AC.Aero.Re    = fc.Re;        % reynolds number (bqased on mean aerodynamic chord)
AC.Aero.M     = fc.M;           % flight Mach number 
%AC.Aero.CL    = fc.CL;          % lift coefficient - comment this line to run the code for given alpha
AC.Aero.Alpha = 3;             % angle of attack -  comment this line to run the code for given cl 


%% 
tic
Res = Q3D_solver(AC);
toc
end