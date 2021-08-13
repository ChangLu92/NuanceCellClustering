function [mz, intensities_array, max_xy_positions_new, nr_of_datapoints_per_pos,nr_of_positions,xy_positions_new,xy_positions] = read_imzML(xml_metafile,binary_filename,jj)


% Get dataset information
imzML = imzMLConverter.ImzMLHandler.parseimzML(xml_metafile);
mz = imzML.getRun().getChildAt(0).getSpectrum(1).getmzArray();
nr_of_datapoints_per_pos = length(mz);   %???????m/z
nr_of_positions = imzML.getRun().getChildAt(0).getChildCount;  %??????

% cols  = imzML.getWidth()
% rows  = imzML.getHeight()

% Check UUID match between imzML (xml) and binary (ibd) file
uuid = char(imzML.getFileDescription().getChildAt(0).getCVParam('IMS:1000080').getValue());

fid1 = fopen(binary_filename);
first = fread(fid1, 16, 'uint8','b');
fclose(fid1);

str = dec2hex(first);
uuid2 = '';
for j=1:size(first,1)
    uuid2 = [uuid2 str(j,:)];
end

uuid(1) = []; uuid(end) = [];
uuid = strrep(uuid, '-', '');
if(strcmpi(uuid, uuid2))
    disp('true');
end


% Read data from binary file
% size_pos = [nr_of_datapoints_per_pos, nr_of_positions];
tic;
fid1 = fopen(binary_filename);
fseek(fid1, 16, 'bof');

mz = imzML.getRun().getChildAt(0).getSpectrum(0).getmzArray();
% mz_0 = fread(fid1, length(mz0), 'double','l'); % ????????????pixel?mz??????
% intensity_0= fread(fid1, length(mz0), 'double','l');

intensities_array=zeros(nr_of_datapoints_per_pos, nr_of_positions);
% mzout=zeros(num_mz, 1);

fprintf('start loop! \n');
mz_array = fread(fid1, nr_of_datapoints_per_pos, 'double','l');
for ii=1:nr_of_positions
    % add the first special pixel in
%     mz = imzML.getRun().getChildAt(0).getSpectrum(ii-1).getmzArray();
%     mz_array = fread(fid1, length(mz), 'double','l');
%     intensities_array = fread(fid1, length(mz), 'double','l');
     % msresample between 400 to 2000
%     [mzout, Intensities(:,ii)] = msresample(mz_array, intensities_array, num_mz, 'Range', [401 1999], 'ShowPlot', false);
%     fprintf('now is running ii= %d jj= %d \n',ii,jj);
    % % intensities_array = fread(fid1, size_pos, 'double','l');
    intensities_array(:,ii) = fread(fid1, nr_of_datapoints_per_pos, 'double','l');
    % % intensities_array(:,ii) = fread(fid1, nr_of_datapoints_per_pos, 'float','l');
end

% mz_array=mz;
fclose(fid1);
% intensities_array=single(intensities_array);
% mz_array=single(mz_array);
toc;

% Read xy positions
xy_positions = zeros(nr_of_positions, 2);
for i=1:nr_of_positions
    x = imzML.getRun().getChildAt(0).getSpectrum(i-1).getScanList().getScan(0).getCVParam('IMS:1000050').getValue();
    y = imzML.getRun().getChildAt(0).getSpectrum(i-1).getScanList().getScan(0).getCVParam('IMS:1000051').getValue();
    xy_positions(i,:)= [str2double(x) str2double(y)];
end
% ??????????????
xy_positions_new = xy_positions - repmat(min(xy_positions),size(xy_positions,1),1);
xy_positions_new = xy_positions_new + 1;
max_xy_positions_new = max(xy_positions_new);
end

