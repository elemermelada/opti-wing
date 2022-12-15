function [fid]=write_init(par)
%%%_____Routine to write the input file for the EMWET procedure________% %%

fid = fopen(par.namefile,'w');
fprintf(fid, '%g %g \n',par.MTOW,par.MZF);
fprintf(fid, '%g \n',par.nz_max);

fprintf(fid, '%g %g %g %g \n',par.wing_surf*2,(par.b1+par.b2)*2,par.section_num,par.airfoil_num);

fprintf(fid, '0 %s \n',par.Airfoil_root);
fprintf(fid, '%s %s \n',(par.b1)/(par.b1+par.b2),par.Airfoil_kink);
fprintf(fid, '1 %s \n',par.Airfoil_out);
fprintf(fid, '%g %g %g %g %g %g \n',par.root_chord,0,0,0,par.spar_front,par.spar_rear);
fprintf(fid, '%g %g %g %g %g %g \n',par.root_chord*par.taper1,par.b1*tand(par.sweep1),par.b1,0,par.spar_front,par.spar_rear);
fprintf(fid, '%g %g %g %g %g %g \n',par.root_chord*par.taper1*par.taper2,(par.b1*tand(par.sweep1))+(par.b2*tand(par.sweep2)),par.b1+par.b2,0,par.spar_front,par.spar_rear);

fprintf(fid, '%g %g \n',par.ftank_start,par.ftank_end);

fprintf(fid, '%g \n', par.eng_num);
fprintf(fid, '%g  %g \n', par.eng_ypos,par.eng_mass);

fprintf(fid, '%g %g %g %g \n',par.E_al,par.rho_al,par.Ft_al,par.Fc_al);
fprintf(fid, '%g %g %g %g \n',par.E_al,par.rho_al,par.Ft_al,par.Fc_al);
fprintf(fid, '%g %g %g %g \n',par.E_al,par.rho_al,par.Ft_al,par.Fc_al);
fprintf(fid, '%g %g %g %g \n',par.E_al,par.rho_al,par.Ft_al,par.Fc_al);

fprintf(fid,'%g %g \n',par.eff_factor,par.pitch_rib)
fprintf(fid,'1 \n')
fclose(fid)

end