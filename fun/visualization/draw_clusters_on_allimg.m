function draw_clusters_on_allimg(labels,img,mix_pos, begin_idx,clu_meth_name,no,newfolder,foldername)
global clr
num_pic = length(img);
sub =  ceil(sqrt(num_pic));
begin_idx=[begin_idx;length(labels)+1];
[height,width,~]= size(img{1});
for ii = 1: num_pic
    figure(num_pic);  % define figure
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',scrsz);
    %     subplot(sub,sub,ii);
    pos = mix_pos{ii};
    cluster = labels(begin_idx(ii):begin_idx(ii+1)-1);
    pic=zeros(height,width);
    unqValues = unique(labels);
    for j=1:length(pos)
        point=pos{j};
        [num,~]=size(point);
        for jj=1:num
            pic(point(jj,2),point(jj,1))=find(unqValues==cluster(j));
        end
    end
    pic_color=img{ii};
    for j = 1:length(no)
        [row,col] = find(pic==j);
        for i = 1: length(row)
            pic_color(row(i),col(i),:)=clr(find(unqValues==no(j)),:)*255;
            %           pic_color(row(i),col(i),:)=color(j,:);
        end
    end
    image(pic_color);
    axis off
    suptitle([clu_meth_name,'  cell clusters on', '']);
    directory = [newfolder,'\results\',foldername,filesep,clu_meth_name,filesep];
    if ~exist(directory,'dir')
        mkdir(directory);
    end
    print(gcf,'-dpng',[directory,num2str(no),' cluster_plaque.jpg']);
end


end
