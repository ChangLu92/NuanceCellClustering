function p = perc_poscell_percluster(datapath, fileNames, markername, selected_idx, labels)
% percentage of positive cells per cluster

    uni_cluster = unique(labels);
    ki=[];
    for i= 1:length(fileNames)
        load([datapath,filesep,fileNames{i},filesep,markername,'.mat']);
        ki=[ki;posmarker(selected_idx{i})];
    end
    
    p=zeros(1,length(uni_cluster));
    for i = 1:length(uni_cluster)
        p(i) = sum(ki(labels==uni_cluster(i)))/sum(labels==uni_cluster(i));
    end

end
