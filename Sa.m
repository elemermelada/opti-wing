%% RETURNS THE SHAPE FUNCTION FOR A GIVEN INPUT VECTOR
function [S] = Sa(a)
n = size(a,2);
S = @(x) 0;
for i=1:n
    S = @(x) S(x) + nchoosek(n-1,i-1).*a(i)*x.^(i-1)*(1-x)^(n-i);
end
end

