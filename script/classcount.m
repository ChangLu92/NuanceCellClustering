% cell count per class in each cluster


%% load clusters and intergreted intensity
load([datapath,filesep, 'cellmarker_rescale_intergration_t=',num2str(t),'.mat']);
load([datapath, filesep,clustername]);
labels=double(labels);


directoryresult = [directory,'cellmarker_rescale_intergration_t=',num2str(t),clustername,filesep];
if ~exist(directoryresult,'dir')
    mkdir(directoryresult);
end


%% number of cell per folder
T = readtable(tablename);
bindtable = table(labels,foldername);
bindtable.Properties.VariableNames{'foldername'} = 'FolderNumber';
TT = join(bindtable,T,'Keys','FolderNumber');

uniclu = unique(labels);
for i = 1:length(uniclu)
   tablei =  tabulate(  table2array(  TT(table2array( TT(:,1) )==uniclu(i),4))  ) ;
   T = array2table(tablei);
   T.Properties.VariableNames(1:3) = {'Cluster','count','percentage'};
   filename = fullfile(directoryresult, 'cell_count_per_class_in_each_cluster.xlsx');
   writetable(T,filename,'Sheet',['Cluster ', num2str(uniclu(i))]) ;
end


