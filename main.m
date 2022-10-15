%% INIT
clear
close all
clc

%% GET INITIAL STATE VECTOR
%%ORIGINAL AIRFOIL
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

%% OPTIMIZER