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

figure(34)
clf

%%1
subplot(3,1,1);
axis equal
hold on

cd 'CST'
C = Cnm(0.5,1);
CSText = y.CST1(1:size(y.CST1,2)/2);
CSTint = y.CST1(size(y.CST1,2)/2+1:end);

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

pgon = polyshape([bounds(1),bounds(1),bounds(2),bounds(2)],[Fext(bounds(1)),Fint(bounds(1)),Fint(bounds(2)),Fext(bounds(2))]);
plot(pgon)

ylim([-0.2,0.2])

c = x(1)*initial.croot;
S1 = (bounds(2)-bounds(1))*(Fext(bounds(1))+Fext(bounds(2))-Fint(bounds(1))-Fint(bounds(2)))/2*c^2;

%%2
subplot(3,1,2);
axis equal
hold on

C = Cnm(0.5,1);
CSText = y.CST2(1:size(y.CST1,2)/2);
CSTint = y.CST2(size(y.CST1,2)/2+1:end);

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

pgon = polyshape([bounds(1),bounds(1),bounds(2),bounds(2)],[Fext(bounds(1)),Fint(bounds(1)),Fint(bounds(2)),Fext(bounds(2))]);
plot(pgon)

ylim([-0.2,0.2])

c = x(1)*initial.croot*x(2);
S2 = (bounds(2)-bounds(1))*(Fext(bounds(1))+Fext(bounds(2))-Fint(bounds(1))-Fint(bounds(2)))/2*c^2;

%%3
subplot(3,1,3);
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

pgon = polyshape([bounds(1),bounds(1),bounds(2),bounds(2)],[Fext(bounds(1)),Fint(bounds(1)),Fint(bounds(2)),Fext(bounds(2))]);
plot(pgon)

ylim([-0.2,0.2])

c = x(1)*initial.croot*x(2)*x(3);
S3 = (bounds(2)-.175)*(Fext(bounds(1))+Fext(bounds(2))-Fint(bounds(1))-Fint(bounds(2)))/2*c^2;
cd '..'

drawnow

%get necessary fuel
%get available fuel vol
disp(S1)
disp(S2)
disp(S3)
vreq = couplings.y.Wfuel/0.81715e3
vtank = (S1+S2)/2*parameters.b1+(S2+S3)/2*x(4)*((initial.b2+parameters.b1)*0.9-parameters.b1);
vol = vreq-2*vtank*0.93;
end

