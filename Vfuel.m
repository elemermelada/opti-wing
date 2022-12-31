%% FUNCTION TO OBTAIN THE EXCESS FUEL VOLUME TO COMPLETE THE MISSION
%TODO - make sure that necessary fuel is only evaluated ONCE per iteration...
function [vol] = Vfuel(x)

y.CST1 = x(8:19);
y.CST3 = x(20:31)*0.85+x(8:19)*0.15;
y.CST2 = (x(8:19)+x(20:31))./2;

figure(34)
clf
axis equal
hold on

C = Cnm(0.5,1);
CSText = y.CST3(1:size(y.CST1,2)/2);
CSTint = y.CST3(size(y.CST1,2)/2+1:end);

S = Sa(CSText);
Fext = @(x) C(x).*S(x);
p=ezplot(Fext,[0,1]);
p.LineWidth = 1.5;
p.Color = "blue";

S = Sa(CSTint);
Fint = @(x) C(x).*S(x);
p=ezplot(Fint,[0,1]);
p.LineWidth = 1.5;
p.Color = "blue";

pgon = polyshape([0.175,0.175,0.575,0.575],[Fext(0.175),Fint(0.175),Fint(0.575),Fext(0.575)]);
plot(pgon)

ylim([-0.2,0.2])

title(num2str(y.CST3))
drawnow

%get necessary fuel
%get available fuel vol
vol = 1;
end

