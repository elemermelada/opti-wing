%% INIT
clear
close all
clc

%% GET INITIAL STATE VECTOR
[y, Cd_aw_0, W_aw]=init_cond  %W_aw [kg], Cd_aw_0/(S1+S1)

%% OPTIMIZER