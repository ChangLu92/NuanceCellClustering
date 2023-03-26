function draw_poski67_singleheimg(labels,ki,plaquesname,nuancename,clus,mix_pos,begin_idx,clu_meth_name,newfolder,foldername,color)
imgi=imread([newfolder,filesep,'Nuance',filesep,plaquesname,filesep,'HE.jpg']);
idx = find(strcmp(nuancename, plaquesname));
pos =mix_pos{idx};
begin_idx=[begin_idx;length(labels)+1];
idx_ki = find(ki>1);
for i=1:length(clus)
    idx_no = find(labels==clus(i));
    new_idx=idx_no(idx_no>begin_idx(idx)-1&idx_no<begin_idx(idx+1));
    [newidx_kino,ia, ib]  = intersect(new_idx,idx_ki);
    flag=zeros(size(new_idx));
    flag(ia)=1;
    idxi=new_idx-begin_idx(idx)+1;
    new_pos = pos(idxi);
    
    for jj=1:length(new_pos)
        px = new_pos{jj};
        [num,~]=size(px);
        if flag(jj)==0
            c = color(1,:);
        else
            c = color(2,:);
        end
        for j=1:num %?????????????
            imgi(px(j,2),px(j,1),1)=c(1);
            imgi(px(j,2),px(j,1), 2)=c(2);
            imgi(px(j,2),px(j,1), 3)=c(3);
        end
    end
end

fig=figure;  % define figure
imshow(imgi);
title([plaquesname,' cluster',num2str(clus)])
axis off

directory = [newfolder,'\results\',foldername,filesep,clu_meth_name,filesep];
if ~exist(directory,'dir')
    mkdir(directory);
end
imwrite(imgi,[directory,plaquesname,'-',num2str(clus),'-ki67.jpg'])
% print(gcf,'-dpng',[directory,plaquesname,'_',num2str(clus),'.jpg']);
close(fig);

end
