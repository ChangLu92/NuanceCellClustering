function drawinchonhe(inichno,inichcluster,neigh_adj_mat,labels,plaquesname,idx,mix_pos,begin_idx,clu_meth_name,newfolder,foldername)
global clr
% no is a vector
begin_idx=[begin_idx;length(labels)+1];
img=imread([newfolder,filesep,'Nuance',filesep,plaquesname,filesep,'HE.jpg']);
pos = mix_pos{idx};
cluster = labels(begin_idx(idx):begin_idx(idx+1)-1);
unqValues = unique(labels);

inichclu=inichcluster(begin_idx(idx):begin_idx(idx+1)-1);
[x,y]=find(neigh_adj_mat(inichclu==inichno,:)==1);

pos_new = pos(unique(y));
cluster_new = cluster(unique(y));
pic_color=img;
for j=1:length(pos_new)
    point=pos_new{j};
    [num,~]=size(point);
    for jj=1:num
        pic_color(point(jj,2),point(jj,1),:)=clr(unqValues==cluster_new(j),:)*255;
    end
end
fig=figure;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',scrsz);
image(pic_color);
axis off
suptitle(['inich ', num2str(inichno), ' on ',plaquesname]);
directory = [newfolder,'\results\',foldername,filesep,clu_meth_name,filesep];
if ~exist(directory,'dir')
    mkdir(directory);
end
% print(gcf,'-dpng',[directory, num2str(length(no)),' ',plaquesname, ' cluster_plaque.jpg']);
imwrite(pic_color,[directory, 'inich ', num2str(inichno),' on ',plaquesname,'.jpg']);
close(fig);
end

