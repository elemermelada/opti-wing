%% FUNCTION TO OBTAIN THE EXCESS FUEL VOLUME TO COMPLETE THE MISSION
%TODO - make sure that necessary fuel is only evaluated ONCE per iteration...
function [vol] = Vfuel(x)

bounds = [0.1,0.7];

global initial
global parameters
global couplings

y.CST1 = x(8:19);
y.CST3 = x(20:31)*0.85+x(8:19)*0.15;
y.CST2 = (x(8:19)+x(20:31))./2;

%% Volume for first trapezoid
vol1 = integral2(@(eta,nu)wing_surface(y.CST1,y.CST2,x(1)*initial.croot,x(1)*initial.croot*x(2),parameters.b1,eta,nu),0,.85,bounds(1),bounds(1));

%% Volume for second trapezoid
vol2 = integral2(@(eta,nu)wing_surface(y.CST2,y.CST2*0.15 + 0.85*y.CST3,x(1)*initial.croot*x(2),x(1)*initial.croot*x(2)*(0.15+0.85*x(3)),((initial.b2+parameters.b1)*0.85-parameters.b1),eta,nu),0,.85,bounds(1),bounds(2));

%% Volume required
vreq = couplings.y.Wfuel/0.81715e3;
vtank = vol1 + vol2;
vol = vreq-2*vtank*0.93;
end

function height = wing_surface(CST1,CST2,c1,c2,b,eta,nu)
    height = eta.*0;
    for i = 1:size(eta,1)
        for j = 1:size(eta,2)
            etaval = eta(i,j);
            nuval = nu(i,j);
            cd 'CST'
            c = c1.*(1-etaval)+c2.*etaval;
            CST = CST1.*(1-etaval)+CST2.*etaval;
            C = Cnm(0.5,1);
            S = Sa(CST(1:size(CST,2)/2));
            Fext = @(x) C(x).*S(x);
            S = Sa(CST(size(CST,2)/2+1:end));
            Fint = @(x) C(x).*S(x);
            cd '..'
            height(i,j) = (Fext(nuval)-Fint(nuval)).*c^2.*b;
        end
    end
end

