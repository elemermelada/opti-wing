%% Aerodynamic solver setting
function [Res]=Q3D_Start_V1(x,fc,b1,sweep1)
% Wing planform geometry 
%                x    y     z   chord(m)    twist angle (deg) 
AC.Wing.Geom = [0     0     0     x.croot         x.twist1;
                (tand(sweep1)*b1)  b1   0     (x.croot*x.taper1)        ((x.twist1+x.twist2)/2);
                (tand(sweep1)*b1+tand(x.sweep2)*x.b2)  (x.b2+b1)   0   (x.croot*x.taper2*x.taper1)  x.twist2];

% Wing incidence angle (degree)
AC.Wing.inc  = 0;   
            
            
% Airfoil coefficients input matrix
%                    | ->     upper curve coeff.                <-|   | ->       lower curve coeff.       <-| 
AC.Wing.Airfoils   = [x.CST1;
                     x.CST2;
                     x.CST3];


% TODO - Remove this
%AC.Wing.Airfoils   = [0.245725536320516 0.0835791513087489 0.282219129745890 0.0929856342152546 0.293385628144865 0.400516584088780 -0.236955714493727 -0.171774636478909 -0.0494666931461353 -0.501483356689230 0.0772045397719118 0.342216828644832;
%                     0.245725536320516 0.0835791513087489 0.282219129745890 0.0929856342152546 0.293385628144865 0.400516584088780 -0.236955714493727 -0.171774636478909 -0.0494666931461353 -0.501483356689230 0.0772045397719118 0.342216828644832;
%                     0.245725536320516 0.0835791513087489 0.282219129745890 0.0929856342152546 0.293385628144865 0.400516584088780 -0.236955714493727 -0.171774636478909 -0.0494666931461353 -0.501483356689230 0.0772045397719118 0.342216828644832];
                  
AC.Wing.eta = [0; (b1/(b1+x.b2)); 1];  % Spanwise location of the airfoil sections

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
AC.Aero.CL    = fc.CL;          % lift coefficient - comment this line to run the code for given alpha
%AC.Aero.Alpha = 7;             % angle of attack -  comment this line to run the code for given cl 


%% 
tic
Res = Q3D_solver(AC);
toc
end