function draw_clusters_on_allimgsinglefig(labels,plaquesname,nuancename, no, mix_pos,begin_idx,clu_meth_name,newfolder,color,directory)
global clr
% no is a vector
begin_idx=[begin_idx;length(labels)+1];

idx = find(strcmp(nuancename, plaquesname));
img=imread([newfolder,filesep,'Nuance',filesep,plaquesname,filesep,'HE.jpg']);
[height,width,~]= size(img);
pos = mix_pos{idx};
cluster = labels(begin_idx(idx):begin_idx(idx+1)-1);
pic=zeros(height,width);
unqValues = unique(labels);
for j=1:length(pos)
    point=pos{j};
    [num,~]=size(point);
    for jj=1:num
        pic(point(jj,2),point(jj,1))=find(unqValues==cluster(j));
    end
end
pic_color=img;
for j = 1:length(no)
    [row,col] = find(pic==j);
    for i = 1: length(row)
        if color ==0
            pic_color(row(i),col(i),:)=clr(find(unqValues==no(j)),:)*255;
        else
            pic_color(row(i),col(i),:)=color;
        end
        %           pic_color(row(i),col(i),:)=color(j,:);
    end
    
end
fig=figure;
% scrsz = get(0,'ScreenSize');
% set(gcf,'Position',scrsz);
image(pic_color);
axis off
suptitle([clu_meth_name, ' ',plaquesname,' cell clusters on plaques']);
% directory = [newfolder,'\results\',foldername,filesep,clu_meth_name,filesep];
% if ~exist(directory,'dir')
%     mkdir(directory);
% end
% print(gcf,'-dpng',[directory, num2str(length(no)),' ',plaquesname, ' cluster_plaque.jpg']);
imwrite(pic_color,[directory, num2str(no(1)),' ',plaquesname, ' cluster_plaque.jpg']);
close(fig);
end
