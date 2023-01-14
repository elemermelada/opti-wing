function [fad]=optim(x)

    % Save x to file
    fileID = fopen("lastXEval.txt", "w");
    fprintf(fileID,'%s',num2str(x));

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

figure(1)
clf
cd 'EMWET 1.5'\
id='A';
CST=[y.CST1(1:6), y.CST1(7:12)];
subplot(3,1,1)
[CST_A]=write_xy(CST,id);
id='B'
CST=[y.CST2(1:6), y.CST2(7:12)];
subplot(3,1,2)
[CST_B]=write_xy(CST,id);
id='C'
CST=[y.CST3(1:6), y.CST3(7:12)];
subplot(3,1,3)
[CST_C]=write_xy(CST,id);
cd '..'

%% Plot planform
% figure(2)
% clf
% hold on
% axis equal
% plot_planform(initial.X0, true)
% plot_planform(x, false)
% drawnow

%% Plot ISO
figure(3)
clf
hold on
axis equal
plot_planform(x, false)
res = 5;
for i=0:res
    CST = y.CST1*(res-i)/res + y.CST2*i/res;
    c = initial.croot*((res-i)/res+x(2)*i/res);
    y_0_leading = parameters.b1*i/res;
    x_0_leading = initial.croot-c;
    cd 'CST'
    C = Cnm(0.5,1);
    S = Sa(CST(1:6));
    cd '..'
    Fextra = @(x) C(x).*S(x);
    plot3((0:0.01:1)*0+y_0_leading,initial.croot-x_0_leading-c*(0:0.01:1), Fextra(0:0.01:1)*c, Color="red")
    cd 'CST'
    C = Cnm(0.5,1);
    S = Sa(CST(7:12));
    cd '..'
    Fintra = @(x) C(x).*S(x);
    plot3((0:0.01:1)*0+y_0_leading,initial.croot - x_0_leading- c*(0:0.01:1), Fintra(0:0.01:1)*c, Color="red")
end
res=15
for i=0:res
    CST = y.CST2*(res-i)/res + y.CST3*i/res;
    c = initial.croot*x(2)*((res-i)/res+x(3)*i/res);
    y_0_leading = parameters.b1+initial.b2*x(4)*i/res;
    x_0_leading = initial.croot*(1-x(2))+initial.b2*x(4)*i/res*tand(initial.sweep2*x(5));
    cd 'CST'
    C = Cnm(0.5,1);
    S = Sa(CST(1:6));
    cd '..'
    Fextra = @(x) C(x).*S(x);
    plot3((0:0.01:1)*0+y_0_leading,initial.croot-x_0_leading-c*(0:0.01:1), Fextra(0:0.01:1)*c, Color="red")
    cd 'CST'
    C = Cnm(0.5,1);
    S = Sa(CST(7:12));
    cd '..'
    Fintra = @(x) C(x).*S(x);
    plot3((0:0.01:1)*0+y_0_leading,initial.croot - x_0_leading- c*(0:0.01:1), Fintra(0:0.01:1)*c, Color="red")
end
drawnow

%%Llamada a las disciplinas
%Q3D Loads:
Wtomax = W_aw + y.Wwing_c + y.Wfuel_c; %[kg]
g      = 9.81;
n      = 2.5;
L      = n*Wtomax*g;
ca = 0; %Evaluate Q3D inviscid
[Res0, CMA, S]=Q3Dinit(y,parameters.b1,parameters.sweep1, L, ca);

%EMWET:
MZFW = Wtomax-y.Wfuel_c;
[Wwing]=EMWETinit(Res0, y, parameters.b1, parameters.sweep1, CMA, S, Wtomax, MZFW);
y.Wwing = Wwing;

%Q3D AERO
L  = sqrt(Wtomax*(Wtomax-y.Wfuel_c))*g; %[N]
ca = 1; %Evaluate Q3D viscous
[Res1]=Q3Dinit(y,parameters.b1,parameters.sweep1, L, ca);
y.E = Res1.CLwing / (Res1.CDwing + Cd_aw/(S));

%Breguett:
y.Wfuel = breguett(y.E_c,249.1192, W_aw, y.Wwing_c); %El fuel weight sale en kg

f = W_aw + y.Wwing + y.Wfuel;

%Definition of the extra design variables as global variables:
global couplings;
vararg={y.Wwing,y.E,y.Wfuel,y.Wwing_c,y.E_c,y.Wfuel_c};
couplings.y.Wwing=y.Wwing;
couplings.y.E=y.E;
couplings.y.Wfuel=y.Wfuel;

fad=f/W_tomax_0;
end

function res = plot_planform(x,light)
    global parameters
    global initial
    b1 = parameters.b1;
    c0 = initial.croot;
    b0 = initial.b2;
    
    color ="blue"
    if (light)
        color = "cyan"
    end
    
    c_root = x(1)*c0;
    taper_1 = x(2);
    taper_2 = x(3);
    b_2 = x(4)*b0;
    sweep_2 = x(5)*initial.sweep2;
    
    pgon = polyshape([0,0,b1,b1],[0,c_root,c_root*taper_1,0]);
    plot(pgon, FaceColor=color)
    
    pgon = polyshape([b1,b1,b1+b_2,b1+b_2],[0,c_root*taper_1,c_root*taper_1-b_2*tand(sweep_2),c_root*taper_1-b_2*tand(sweep_2)-c_root*taper_1*taper_2]);
    plot(pgon, FaceColor=color)
    
    xlim([0,18])
    res = 0;
end
