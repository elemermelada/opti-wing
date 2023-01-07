function [out] = plot_planform(x)

    figure(3)
    hold on
    axis equal

    global parameters
    global initial

    b1 = parameters.b1;
    c0 = initial.croot;
    b0 = initial.b2;

    c_root = x(1)*c0;
    taper_1 = x(2);
    taper_2 = x(3);
    b_2 = x(4)*b0;
    sweep_2 = x(5)*initial.sweep2;

    pgon = polyshape([0,0,b1,b1],[0,c_root,c_root*taper_1,0]);
    plot(pgon)
    
    pgon = polyshape([b1,b1,b1+b_2,b1+b_2],[0,c_root*taper_1,c_root*taper_1*taper_2-b_2*tand(sweep_2),0-b_2*tand(sweep_2)]);
    plot(pgon)

    xlim([0,18])

end

