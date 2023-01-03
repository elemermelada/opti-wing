function stop = outputFcn(x,optimValues,state,fileID)
    fprintf(fileID,'%u,%u,%4.2f \r\n',optimValues.iteration,optimValues.funccount, optimValues.fval);
    stop = false;
end
