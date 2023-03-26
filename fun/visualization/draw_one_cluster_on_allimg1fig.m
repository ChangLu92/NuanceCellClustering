function draw_one_cluster_on_allimg1fig(labels,plaquesname,nuancename,clus,mix_pos,begin_idx,clu_meth_name,newfolder,foldername)

imgi=imread([newfolder,filesep,'Nuance',filesep,plaquesname,filesep,'HE.jpg']);
idx = find(strcmp(nuancename, plaquesname));
pos =mix_pos{idx};
begin_idx=[begin_idx;length(labels)+1];
for i=1:length(clus)
    idx_no = find(labels==clus(i));
    new_idx=idx_no(idx_no>begin_idx(idx)-1&idx_no<begin_idx(idx+1));
    idxi=new_idx-begin_idx(idx)+1;
    new_pos = pos(idxi);
    for jj=1:length(new_pos)
        % red RGB
        px = new_pos{jj};
        [num,~]=size(px);
        for j=1:num %?????????????
            imgi(px(j,2),px(j,1),1)=255;
            imgi(px(j,2),px(j,1), 2)=0;
            imgi(px(j,2),px(j,1), 3)=0;
        end
    end
end
fig=figure;  % define figure
% scrsz = get(0,'ScreenSize');
% set(gcf,'Position',scrsz);
imshow(imgi);
title([plaquesname,' cluster',num2str(clus)])
axis off

directory = [newfolder,'\results\',foldername,filesep,clu_meth_name,filesep];
if ~exist(directory,'dir')
    mkdir(directory);
end
imwrite(imgi,[directory,plaquesname,'_',num2str(clus),'.jpg'])
% print(gcf,'-dpng',[directory,plaquesname,'_',num2str(clus),'.jpg']);
close(fig);
end