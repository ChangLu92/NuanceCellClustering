% main file
% Author: Chang Lu
% c.lu@maastrichtuniversity.nl

clear all

% you can put your data folder under 'data' 
currentFolder = pwd;
datapath = [currentFolder,filesep,'data',filesep,'mix with cd163'];

% or set you own path( replace the sentence above to the example below):
% datapath = 'F:\New folder\mix with cd163'; % your own data path

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
% input: .zip file
extractzip(datapath, fileNames);

%% step 2 getCellNuanFeaMat
run('getCellNuanFeaMat.m');

%% step 3 : combine all cells
t=3;
run('nuancematcombination.m');

%% step 4 : SAVE the intergrated cell intensities
run('SAVEnuancematcombination.m');
fprintf('file name is %s \n', ['cellmarker_rescale_intergration_t=',num2str(t),'.mat'])


%% step 5: clustering 
k = 10;
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
% the number of cell per cluster is saved in 'cellcountpercluster.xlsx'
% the number of cell per folder is saved in 'cellcountperfolder.xlsx'
% the number of cell per cluster in each folder is saved in 'cell count per cluster in each folder.xlsx'
% other visualization including: tsne, MST and cell location on H&E images
% (For example , 'TP11' means the cell cluster 1 on 'TP1' image)

clustername = [dn, '_kmedoids_k=', num2str(k)];
run('ClusteringAnalysis.m');


