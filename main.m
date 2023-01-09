%% INIT
clear
close all
clc

%% GET INITIAL STATE VECTOR
[y_0, Cd_aw_0, W_aw, Wtomax_0, S, b1, sweep1]=init_cond()  %W_aw [kg], Cd_aw_0/(S1+S1)

global parameters;
parameters.W_aw     = W_aw;
parameters.Cd_aw    = Cd_aw_0;
parameters.Wtomax_0 = Wtomax_0;
parameters.S_0      = S;
parameters.b1       = b1;
parameters.sweep1   = sweep1;

global initial;
initial.croot=y_0.croot;
initial.taper1=y_0.taper1;
initial.taper2=y_0.taper2;
initial.b2=y_0.b2;
initial.sweep2=y_0.sweep2;
initial.twist1=y_0.twist1;
initial.twist2=y_0.twist2;
initial.CSTr=y_0.CST1;
initial.CSTk=y_0.CST2;
initial.CSTt=y_0.CST3;
initial.Wwing_0=y_0.Wwing_0;
initial.E_0=y_0.E_0;
initial.Wfuel_0=y_0.Wfuel_0;

%% OPTIMIZER
%Order vector y: croot,taper1,taper2,b2,sweep2,twist1,twist2,CSTroot(1,12),CSTkink(1,12),CSTtip(1,12),Wwing,E,Wfuel
%TODO: hay que adimensionalizar, vector inial y_0 y constraints

X0 = [1,y_0.taper1,y_0.taper2,1,1,1,1,y_0.CST1,y_0.CST3,1,1,1];

LB = [0.6, 0.2, 0.2, 0.8, 0.8, -0.5, -0.5, ...
    min(X0(8:31)*0.6,X0(8:31)*1.4), ...
    0.5, 0.6, 0.6];

UB = [1.5, 1, 1, 1.2, 1.2, 1.1, 1, ...
    max(X0(8:31)*0.6,X0(8:31)*1.4), ...
    1.4, 1.5, 1.4];

% Options for the optimization
options.Display         = 'iter-detailed';
options.Algorithm       = 'sqp';
options.FunValCheck     = 'off';
options.DiffMinChange   = 0.0001;       % Minimum change while gradient searching
options.DiffMaxChange   = 0.05;         % Maximum change while gradient searching
options.TolCon          = 0.0001;       % Maximum difference between two subsequent constraint vectors [c and ceq]
options.TolFun          = 1e-9;         % Maximum difference between two subseque
options.TolX            = 1e-9;
options.MaxIterations   = 50;
options.PlotFcns = {@optimplotx,@optimplotfval,@optimplotfirstorderopt};
options.OutputFcn = @(x) outF(x);

%sol = ga(@(x)optim(x),size(LB,2),[],[],[],[],LB,UB,@(x)constraints(x));
sol = fmincon(@(x)optim(x),X0,[],[],[],[],LB,UB,@(x)constraints(x),options);

function stop = outF(x)
    fileID = fopen("lastXIter.txt", "w");
    fprintf(fileID,'%s',num2str(x));
    stop = false;
end