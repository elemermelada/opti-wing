function [CST_id]=writexy(CST,id)
    load("orig.mat")
    airfoilPoints = 15;
    airfoilStep = 0.5/airfoilPoints;
    CSTextra=CST(1:6);
    CSTintra=CST(7:12);
    CST_id = [CSTextra,CSTintra];
    C = Cnm(0.5,1);
    S = Sa(CSTextra);
    Fextra = @(x) C(x).*S(x);
    x_airfoil = (1-sin(pi*(0:airfoilStep:0.5)))';
    y_airfoil = Fextra(x_airfoil);
    C = Cnm(0.5,1);
    S = Sa(CSTintra);
    Fintra = @(x) C(x).*S(x);
    x_airfoil = [x_airfoil;(1-sin(pi*(0.5+airfoilStep:airfoilStep:1)))'];
    y_airfoil = [y_airfoil;Fintra((1-sin(pi*(0.5+airfoilStep:airfoilStep:1)))')];
    writematrix([x_airfoil,y_airfoil],"AIRFOIL_" + id + ".dat",'Delimiter','tab')

    figure(1)
    clf
    hold on
    axis equal
    p=ezplot(Fextra,[0,1]);
    p.LineWidth = 1.5;
    p.Color = "red";
    p=ezplot(Fintra,[0,1]);
    p.LineWidth = 1.5;
    p.Color = "red";
    scatter(whitcomb_intra(:,1),whitcomb_intra(:,2),50,"blue","X","LineWidth",1)
    scatter(whitcomb_extra(:,1),whitcomb_extra(:,2),50,"blue","X","LineWidth",1)
    ylim([-0.2,0.2])
    xlabel("")
    title("Original Point Cloud vs. CST Parametrization")
end