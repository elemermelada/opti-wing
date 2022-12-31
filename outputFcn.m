function stop = outputFcn(x,optimValues,state,fileID)
    fid = fopen('tryme.txt', 'a');
    fprintf(fid, "%s\n", "probando");
    fclose(fid);
    fprintf(fileID,'%u,%u,%4.2f \r\n',optimValues.iteration,optimValues.funccount, optimValues.fval)
end
