function [c, ceq]=constraints(x)

global couplings;
y.E     = couplings.y.E;
y.Wwing = couplings.y.Wwing;
y.Wfuel = couplings.y.Wfuel;

y.Wwing_c = x(end-2);
y.E_c     = x(end-1);
y.Wfuel_c = x(end);

global initial;
croot_0=initial.croot;
taper1_0=initial.taper1;
taper2_0=initial.taper2;
b2_0=initial.b2;
E_0=initial.E_0;
Wwing_0=initial.Wwing_0;
Wfuel_0=initial.Wfuel_0;

ceq1 = 100*abs(y.E - y.E_c*E_0)/(abs(y.E_c*E_0)+0.01);
ceq2 = abs(y.Wwing - y.Wwing_c*Wwing_0)/(abs(y.Wwing_c*Wwing_0)+0.01);
ceq3 = abs(y.Wfuel - y.Wfuel_c*Wfuel_0)/(abs(y.Wfuel_c*Wfuel_0)+0.01);

if isnan(ceq1) ceq1 = 99; end
if isnan(ceq2) ceq2 = 1; end
if isnan(ceq3) ceq3 = 1; end

ceq=[ceq1, ceq2, ceq3];

%%TODO: Inequality constraint concerning the fuel tank, c2
c2=Vfuel(x);

%Inequality constraint for the wing-loading.
global parameters;
Wtomax_0=parameters.Wtomax_0;
Sref=parameters.S_0;
b1= parameters.b1;
W_aw=parameters.W_aw;

c1=((W_aw+y.Wwing+y.Wfuel)/((b1/2*(x(1)*croot_0+x(1)*croot_0*x(2)))+(x(4)*b2_0/2*(x(1)*croot_0*x(2)+x(1)*croot_0*x(2)*x(3)))))-(Wtomax_0/Sref);
c=[c1,c2];

end