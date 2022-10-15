%% RETURNS THE CLASS FUNCTION FOR A GIVEN n AND m
function [C] = Cnm(n,m)
%CNM Summary of this function goes here
%   Detailed explanation goes here
C = @(x) (x).^n.*(1-x).^m;
end

