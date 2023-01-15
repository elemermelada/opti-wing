function [Res, CMA, S]=Q3Dinit(y,b1,sweep1, L, ca)

    %%Q3D LOADS:
    %CMA calculation
    CMA1    = 2/3*y.croot*((y.taper1+1)/(y.taper1^2+y.taper1+1));
    c_kink  = y.taper1*y.croot;
    CMA2    = 2/3*c_kink*((y.taper2+1)/(y.taper2^2+y.taper2+1));    
    S1      = (y.croot+c_kink)*b1/2;
    c_tip   = y.croot*y.taper2*y.taper1;
    S2      = (c_kink+c_tip)*y.b2/2;
    CMA     = CMA1*S1/(S1+S2)+CMA2*S2/(S1+S2);
    S       = S1+S2;
    
    if ca==0
        %Flight conditions for Q3d inviscid
        fc.V     = 249.1192;            % flight speed (m/s)
        fc.rho   = 0.3804;         % air density  (kg/m3)
        fc.alt   = 10668;             % flight altitude (m)
        fc.visc  = 0;
        visc     = 8.9E-6;
        fc.Re    = fc.V*fc.rho*CMA/visc;        % reynolds number (bqased on mean aerodynamic chord)
        fc.M     = 0.84;           % flight Mach number 
        fc.CL    = L/(1/2*fc.rho*(fc.V^2)*2*(S1+S2)); %2*(S1+S2), S1+S2 es la superficie alar de un semiala
    else 
        %Flight conditions for Q3d
        fc.V     = 233.9941;            % flight speed (m/s)
        fc.rho   = 0.3804;         % air density  (kg/m3)
        fc.alt   = 10668;             % flight altitude (m)
        fc.visc  = 1;
        visc     = 8.9E-6;
        fc.Re    = fc.V*fc.rho*CMA/visc;        % reynolds number (bqased on mean aerodynamic chord)
        fc.M     = 0.789*0+0.75;           % flight Mach number 
        fc.CL    = L/(1/2*fc.rho*(fc.V^2)*2*(S1+S2)); %2*(S1+S2), S1+S2 es la superficie alar de un semiala
    end
    
    cd 'Q3D'
    Res=Q3D_Start_V1(y,fc,b1,sweep1);
    cd '..'    
     
end