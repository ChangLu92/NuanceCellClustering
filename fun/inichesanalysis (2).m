function [cluster, neigh_adj_cell]=inichesanalysis(labels,nuancename, mixpos,begin_idx, r, k, newfolder,directory, clustername)
%INICHESANALYSIS Summary of this function goes here
%   Detailed explanation goes here
% labels=labels';
 begin_idx=[begin_idx;length(labels)+1];
 unq_label=unique(labels);
 inich_mat = zeros(length(labels),length(unq_label));
 for ii=1:length(mixpos)
%      load([nuancefolder,filesep,nuancenameFolds{ii},filesep,'cellintensity.mat']);
     pos=mixpos{ii};
%      img=miximg{ii};
     img=imread([newfolder,filesep,'Nuance',filesep,nuancename{ii},filesep,'HE.jpg']);
%      idxii=removal_idx{ii};
     [neigh_adj_mat, dist_mat, centroids] = build_neigh_adjacentmat(img,pos,0);
     neigh_adj_mat(dist_mat>r)=0;
     
% img=imread('E:\code\MyProject\data\final data\results\cellmarker_compen_rescale_-1_v2_intergration_148_t=3\cosine_kmedoids_k=70\1 Mouse 10 root 1 plaque 1 cluster_plaque.jpg');     
%      figure;
%      imshow(img); hold on
%      scatter(centroids(:,1),centroids(:,2),'y*'); hold on
%      axis off
%      gplot(neigh_adj_mat,centroids,'-.g');
     
%      pos_new=pos;
%      pos_new(dist_mat<r)
%      neigh_adj_mat(idxii,:)=[];
      labelii=labels(begin_idx(ii):begin_idx(ii+1)-1);
     for jj=1:size(neigh_adj_mat,1)
       tbl = tabulate(labelii(neigh_adj_mat(jj,:)==1));
       if ~isempty(tbl)
       tbl(tbl(:,3)==0,:)=[];
       label_idx=unq_label==tbl(:,1)';
       inich_mat(begin_idx(ii)+jj-1,logical(sum(label_idx,2)))=tbl(:,3)/100;
       end
     end
     neigh_adj_cell{ii}=sparse(neigh_adj_mat);
 end
 idx = find(sum(inich_mat,2)~=0);
 new_inich_mat=inich_mat(idx,:);
 [clu,cen] = kmeans(new_inich_mat,k);
 
 cluster=ones(size(inich_mat,1),1)*-1;
 cluster(idx)=clu;
 
%  HeatMap(cen','RowLabels',unq_label , 'ColumnLabels', unique(clu));
%     figure;  % define figure
%     scrsz = get(0,'ScreenSize');
%     set(gcf,'Position',scrsz);
CGObject=clustergram(cen','cluster',2,'RowLabels',clustername , 'ColumnLabels', unique(clu), 'Colormap',redbluecmap,'Symmetric',false);
scrsz = get(0,'ScreenSize'); set(gcf,'Position',scrsz);
h1=plot(CGObject);
colorbar(h1,'southoutside');
addTitle(CGObject, 'i-niche heatmap');
scrsz = get(0,'ScreenSize'); set(gcf,'Position',scrsz);
% title([clu_meth_name,'  inich_heatmap']);
% directory = [newfolder,'\results\',fordername,filesep,meth_name,filesep];
% if ~exist(directory,'dir')
%     mkdir(directory);
% end
% savefig(CGObject,[directory,'inich_heatmap.fig']);
% saveas(gcf,[directory,'inich_heatmap.jpg']);
print(gcf,'-dpng',[directory,'iniche_heatmap_k=',num2str(k),'.jpg']);
end

