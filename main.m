% main file
% Author: Chang Lu
% c.lu@maastrichtuniversity.nl

clear all

% you can put your data folder under 'data' 
currentFolder = pwd;

% datapath = [currentFolder,filesep,'data',filesep,'mix with cd163'];
% or set you own path( replace the sentence above to the example below):
datapath = 'G:\colleagues\Elias\230622_nuance_testdata_Chang_EW'; % your own data path

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
% add the pics you would like to cluster
pic = {'I_Dectin1 PerCPeF710';'I_MHCII PEeF610';'I_Plin2 A488';'SBA_BV605 CD68';'SBA_CD206 BV650';'SBA_CD44 eF506';'SBA_Ly6C e450'};
% the name of 7aad image
nucleipic = '';
run('getCellNuanFeaMat.m');

%% step 3 : combine all cells
t=3;
run('nuancematcombination.m');

%% step 4 : SAVE the intergrated cell intensities
run('SAVEnuancematcombination.m');
fprintf('file name is %s \n', ['cellmarker_rescale_intergration_t=',num2str(t),'.mat'])


%% step 5.1: clustering parameter
k = 10;
dn = 'cosine';


%% step 5.2: clustering 
% use cell-nuance intensity matrix (from step 4) to get clusters by
% k-mediods
load([datapath,filesep, 'cellmarker_rescale_intergration_t=',num2str(t),'.mat']);
fprintf('k= %d \n',k);
[labels,~,~] = kmedoids(norm_inten, k,'Distance',dn);
centers=getmedian(norm_inten, labels);
save([datapath, filesep, dn, '_kmedoids_k=', num2str(k),'.mat'], 'labels', 'centers','dn');


%% step 6 : visulization
clustername = [dn, '_kmedoids_k=', num2str(k)];

%% step 6.1: visualization on mst, tsne and h&e
% the number of cell per cluster is saved in 'cellcountpercluster.xlsx'
% the number of cell per folder is saved in 'cellcountperfolder.xlsx'
% the number of cell per cluster in each folder is saved in 'cell count per cluster in each folder.xlsx'
% other visualization including: tsne, MST and cell location on H&E images
% (For example , 'TP11' means the cell cluster 1 on 'TP1' image)
run('ClusteringAnalysis.m');

%% step 6.2: number of cells per class
tablename = 'G:\colleagues\Elias\230622_nuance_testdata_Chang_EW\220624_Mafdko_ID.xlsx';
run('classcount.m')


%% step 6.3: visualization of ki67+
% ki67pic = 'I_Ki67 PECy5';
% run('overlayki67andnuclei');
% 
% ki=[];
% for i= 1:length(plaquesname)
%     load([nuancefolder,plaquesname{i},filesep,'poski67.mat']);
%     ki=[ki;poski67(selected_idx{i})];
% end
% p=zeros(1,length(uni_cluster));
% for i = 1:length(uni_cluster)
%     p(i) = sum(ki(labels==uni_cluster(i)))/sum(labels==uni_cluster(i));
% end
% c = categorical(1:length(uni_cluster));
% 
% 
% figure; bar(c,p);
% xlswrite([directory,'ki67-70.xlsx'],[1:length(uni_cluster);p]);
% 
% fig = draw_SPADE_tree_with_msfeatures(labels, centers,'cosine',p);
% figname = 'ki67+';
% saveas(fig,[directory,name,'.jpg'])






