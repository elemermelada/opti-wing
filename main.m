%% INIT
clear
close all
clc
delete constrHistory.txt

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

X0 = [1,y_0.taper1,y_0.taper2,1,1,0,0,y_0.CST1,y_0.CST3,1,1,1];
initial.X0 = X0;
%X0 = [1.14092683927078	0.783728530880358	0.351889227751475	0.966728353248564	0.910597279828490	1.00021911864591	0.990103958311672	0.286177610386722	0.239114147352305	0.264763622029200	0.229356819937411	0.341905724415031	0.330581219391479	-0.0761869129221681	-0.114691668716845	0.0168229490367192	-0.323021873646630	0.153449999333804	0.101378166813434	0.177709125837177	0.101766175833523	0.154645904978813	0.131397504351952	0.260106440721660	0.136975974209266	-0.0545215351930693	-0.0669133383588592	0.00908338639730226	-0.188234417332000	0.0866607691527729	0.0568735941831161	0.697392193413338	1.12051609470238	0.845592086057893];

CSTbounds = [0.7,1.3];
CSTmin = min(X0(8:31)*CSTbounds(1),X0(8:31)*CSTbounds(2));
CSTmax = max(max(X0(8:31)*CSTbounds(1),X0(8:31)*CSTbounds(2)),CSTmin+0.02);

LB = [0.5, 0.2, 0.2, 0.8, 0.8, -0.5, -0.5, ...
    CSTmin, ...
    0.35, 0.6, 0.6];

UB = [1.5, 1, 1, 1.2, 1.2, 1, 1, ...
    CSTmax, ...
    1.55, 1.6, 1.4];

% Options for the optimization
options.Display         = 'iter-detailed';
options.Algorithm       = 'sqp';
options.FunValCheck     = 'off';
options.DiffMinChange   = 5e-3;       % Minimum change while gradient searching
options.DiffMaxChange   = 1e-1;         % Maximum change while gradient searching
options.TolCon          = 1e-4;       % Maximum difference between two subsequent constraint vectors [c and ceq]
options.TolFun          = 1e-4;         % Maximum difference between two subseque
options.TolX            = 1e-4;
options.MaxIterations   = 30;
options.ScaleProblem    = false;
options.PlotFcns = {@optimplotx,@optimplotfval,@optimplotfirstorderopt};
options.OutputFcn = @(x, optimValues, state) outF(x, optimValues, state);

%X0 = [1.40372797108115	1.00000660656433	0.236080630076172	0.990236327311346	0.917338888669264	0.	0.	0.347624382744632	0.249737987181424	0.234168751276259	0.255930009769722	0.434204502713372	0.216039697605633	-0.108265797844145	-0.124837862428165	0.0353438545080431	-0.391293704201140	0.164826813041413	0.117698512759011	0.198138851261521	0.132017778010458	0.224215687200653	0.154960616671592	0.166537601252933	0.175562786484797	-0.0618801568325760	-0.0754481890312906	0.0100733894387093	-0.141111744619019	0.143561011655053	0.0596424085575251	0.500815084748915	1.06854772386793	0.843787804516344]
%sol = ga(@(x)optim(x),size(LB,2),[],[],[],[],LB,UB,@(x)constraints(x));
X0 = [1.17521053660771	0.944986025053859	0.200328087367584	0.837596163427207	0.850433224437653	-0.0379028302079963	0.0138117029303775	0.347460677657071	0.235260764325485	0.229409024832587	0.201741317461961	0.322340426340527	0.388534829182023	-0.107555869536192	-0.128506806041310	0.0192171541150969	-0.363571444535521	0.152574715914784	0.0918392139003153	0.161325945367710	0.158718292082331	0.136665798476362	0.197964955289514	0.164925669894120	0.144097392983345	-0.0618475213487582	-0.0771053887263340	0.0200987679012112	-0.222904187578413	0.0865516768202322	0.0365391804825336	0.450000000000000	1.40000000000000	0.662098965827260];
tic
[sol,fval,exitflag,output] = fmincon(@(x)optim(x),X0,[],[],[],[],LB,UB,@(x)constraints(x),options);
toc

function stop = outF(x, optimValues, state)
    fileID = fopen("lastXIter.txt", "w");
    fprintf(fileID,'%s',num2str(x));
    fclose(fileID);
    fileID = fopen("constrHistory.txt", "a+");
    [c1, c2] = constraints(x);
    fprintf(fileID,'%s\n',num2str([c1,c2]));
    fclose(fileID);
    stop = false;
end