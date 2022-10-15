%% INIT
clear
close all
clc

%% GET INITIAL STATE VECTOR
%%ORIGINAL AIRFOIL
orig_extra = [  0.000000  0.000000
  0.001900  0.005700
  0.006000  0.010500
  0.007800  0.012000
  0.012900  0.015700
  0.023700  0.021800
  0.050500  0.032400
  0.079400  0.040200
  0.097500  0.044100
  0.151100  0.052400
  0.203600  0.057600
  0.250000  0.060600
  0.296400  0.062300
  0.346800  0.062900
  0.399000  0.062500
  0.444700  0.060800
  0.490400  0.059700
  0.548600  0.052900
  0.609100  0.047000
  0.657100  0.042200
  0.874100  0.018300
  0.947000  0.007600
  1.000000  0.000500];
orig_intra = [  0.000000  0.000000
  0.002200 -0.004000
  0.004900 -0.005700
  0.007000 -0.006600
  0.012500 -0.007600
  0.020900 -0.010100
  0.055500 -0.014700
  0.081600 -0.017400
  0.107800 -0.020100
  0.157100 -0.024700
  0.203600 -0.028600
  0.250000 -0.031900
  0.296400 -0.034700
  0.354900 -0.037000
  0.399600 -0.037500
  0.453200 -0.036600
  0.491100 -0.035200
  0.543400 -0.032800
  0.626900 -0.028200
  0.739600 -0.022000
  0.783200 -0.019000
  0.935400 -0.005600
  1.000000 -0.000500];

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

%% OPTIMIZER