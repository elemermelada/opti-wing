function Wfuel=breguett(E_0,fc,Wtomax)

Ct=1.8639E-4;
R=5365.244; %[km]
Wratio=exp(R*Ct/(fc*E_0))
Wfuel=(1-0.938/Wratio)*Wtomax

end