function [Wwing]=EMWETinit(Res0, y, b1, sweep1, CMA, S, Wtomax, MZFW)
    
    cl    = Res0.Wing.ccl;
    cm    = Res0.Wing.cm_c4;
    yst   = Res0.Wing.Yst;
    w.b1  = b1;
    w.b2  = y.b2;
    w.yst = linspace(0,1,20);
    V     = 249.1192;            % flight speed (m/s)
    rho   = 0.3804;
    q     = 1/2*rho*V^2;
    w.ccl  = interp1(yst,cl*q,w.yst*(w.b1+w.b2),'spline');
    w.cm_c4= interp1(yst,cm*q*CMA,w.yst*(w.b1+w.b2),'spline');
    
    %Initial files
    par.namefile    =    'B737-800.init';
    par.MTOW        =    Wtomax;         %[kg]
    par.MZF         =    MZFW;         %[kg]
    par.nz_max      =    2.5;   
    par.b1          =    b1;
    par.b2          =    y.b2;       %[m]
    par.root_chord  =    y.croot;       %[m]
    par.taper1      =    y.taper1;    
    par.taper2      =    y.taper2;
    par.sweep1      =    sweep1;      %[deg]
    par.sweep2      =    y.sweep2;      %[deg]
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
    par.Airfoil_root=    'AIRFOIL_A';
    par.Airfoil_kink=    'AIRFOIL_B';
    par.Airfoil_out =    'AIRFOIL_C';
    par.section_num =    3;
    par.airfoil_num =    3;
    par.wing_surf   =    S;

    cd 'EMWET 1.5'\
    file1=write_init(par);

    %%Loads file:
    w.namefile=('B737-800.load')
    file2=write_loads(w);

    EMWET('B737-800')
    wing_weight= read_output();
    cd '..'
    Wwing  = wing_weight;
    
end