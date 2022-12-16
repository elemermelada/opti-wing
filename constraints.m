function [c, ceq]=constraints=(x)

global couplings;
y.E     = couplings.y.E;
y.Wwing = couplings.y.Wwing;
y.Wfuel = couplings.y.Wfuel;

y.Wwing_c = x(44);
y.E_c     = x(45);
y.Wfuel_c = x(46);

ceq1 = abs(y.E - y.E_c);
ceq2 = abs(y.Wwing - y.Wwing_c);
ceq3 = abs(y.Wfuel - y.Wfuel_c);

ceq=[ceq1, ceq2, ceq3];

%%TODO: Inequality constraint concerning the fuel tank, c2
%Inequality constraint for the wing-loading.
global parameters;
Wtomax_0=parameters.Wtomax_0;
Sref=parameters.S_0;
b1= parameters.b1;
W_aw=parameters.W_aw;

c1=((W_aw+y.Wwing+y.Wfuel)/((b1/2*(x(1)+x(1)*x(2)))+(x(4)/2*(x(1)*x(2)+x(1)*x(2)*x(3)))))-(Wtomax_0/Sref);
c=[c1,];

end