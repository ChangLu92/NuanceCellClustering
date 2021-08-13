% main file
% Author: Chang Lu
% c.lu@maastrichtuniversity.nl

clear all
% datapath='G:\collegues\Laura\20210616 Sethu analysis\184 RFP';
% datapath='G:\collegues\Laura\20210616 Sethu analysis\179 MafB';
% datapath = 'G:\collegues\Elias\210603 data for chang\mix with cd206';
datapath = 'G:\collegues\Elias\210603 data for chang\mix with cd163';


addpath(genpath('fun'));
directory = [datapath,filesep,'results',filesep];
if ~exist(directory,'dir')
    mkdir(directory);
end

files=dir(fullfile(datapath));
isub = [files(:).isdir];
fileNames={files(isub).name}';
fileNames(ismember(fileNames,{'.','..','results'})) = [];

%% step 1 : extractzip
extractzip(datapath, fileNames);

%% step 2 getCellNuanFeaMat
run('getCellNuanFeaMat.m');

%% step 3 : combine all cells
t=3;
run('nuancematcombination.m');

%% step 4 : SAVE the intergrated cell intensities
run('SAVEnuancematcombination.m');
fprintf('file name is %s', ['cellmarker_rescale_intergration_t=',num2str(t),'.mat'])


%% step 5: clustering 
k = 20;
dn = 'cosine';


%% step 5.1: clustering 
% use cell-nuance intensity matrix (from step 4) to get clusters by
% k-mediods

load([datapath,filesep, 'cellmarker_rescale_intergration_t=',num2str(t),'.mat']);
fprintf('k= %d \n',k);
[labels,~,~] = kmedoids(norm_inten, k,'Distance',dn);
centers=getmedian(norm_inten, labels);
save([datapath, filesep, dn, '_kmedoids_k=', num2str(k),'.mat'], 'labels', 'centers','dn');


%% step 5.2: visualization
clustername = [dn, '_kmedoids_k=', num2str(k),'.mat'];
run('ClusteringAnalysis.m');


