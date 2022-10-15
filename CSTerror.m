%% FUNCTION TO OBTAIN THE ERROR FROM CONVERTING RAW DATA TO CST CURVE
function [err] = CSTerror(x,original)
    err = 0;
    C = Cnm(x(1),x(2));
    S = Sa(x(3:end));
    f = @(x) C(x).*S(x);
    for p=original'
        p=p';
        err = err + (p(2)-f(p(1))).^2;
    end
end

