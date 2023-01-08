function Wfuel=breguett(E_0,fc, W_aw, Wwing_c)

Ct=1.8639E-4;
R=5365.244E3; %[m]
Wratio=exp(-(R*Ct/(fc*E_0)))
Wfuel=(1-0.938*Wratio)*(W_aw + Wwing_c)/(0.938*Wratio)

end