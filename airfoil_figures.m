global initial
CST = [0.198410000000000	0.132230000000000	0.223520000000000	0.154420000000000	0.167310000000000	0.174950000000000	-0.0618480000000000	-0.0750310000000000	0.0103980000000000	-0.141220000000000	0.143340000000000	0.0590990000000000]
cd 'EMWET 1.5'\
figure(4)
write_xy(CST,'deleteme')
cd '..'
title("")
xlabel("$\frac{x}{c}$","Interpreter","latex", "FontSize",16)
ylabel("$\frac{z}{c}$","Interpreter","latex", "FontSize",16)
legend("CST Curve","","Whitcomb")




