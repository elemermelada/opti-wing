function [fid]=write_loads(w)
%%%_____Routine to write the input file for the EMWET procedure________% %%

fid = fopen(w.namefile,'w');

for i=1:length(w.yst)
    fprintf(fid, '%g %g %g \n',w.yst(i),w.cl(i),w.cm(i));
end

fclose(fid)

end