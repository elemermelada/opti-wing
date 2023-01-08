function weight=read_output()

fid = fopen('B737-800.weight','r');
data = textscan(fid, '%sg', 'Delimiter', '\n'); %read all data as string
weight = str2num(data{1}{1}(23:end))

end