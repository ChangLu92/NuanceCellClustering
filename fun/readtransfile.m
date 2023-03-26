% read raw transfer file to a rawmat

function rawmat=readtransfile(rawfile)
fid = fopen(rawfile,'r');
tline1 = fgetl(fid);
ftell(fid)
width = str2double(extractAfter(tline1,'='));
tline2 = fgetl(fid);
ftell(fid)
height = str2double(extractAfter(tline2,'='));
tline3 = fgetl(fid);
ftell(fid)
tline3 = fgetl(fid);
ftell(fid)
rawmat=zeros(width, height,2);
formatSpec = '%f' ;
rawmat(:,:,1) = fscanf(fid,formatSpec, [width height]);
% rawmat(:,:,1)  = fread(fid,[width height], 'double');
tline4 = fgetl(fid);
ftell(fid)
tline4 = fgetl(fid);
ftell(fid)
tline4 = fgetl(fid);
ftell(fid)
rawmat(:,:,2) = fscanf(fid,formatSpec, [width height]);

