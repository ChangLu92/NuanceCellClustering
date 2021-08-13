
%% unzip CELL ROI
% Author: Chang Lu
% c.lu@maastrichtuniversity.nl

function extractzip(datapath, fileNames)

for i = 1:length(fileNames)
    Filedir2 = [datapath,'\',fileNames{i}];
    zipdir = [Filedir2,'\','RoiSet'];
    if exist([zipdir,'.zip'],'file') && ~exist(zipdir,'dir')
        mkdir(zipdir);
        unzip([Filedir2,'\','RoiSet.zip'],zipdir);
    end
end
sprintf('extractzip is done!')

end



