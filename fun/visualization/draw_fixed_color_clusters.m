function draw_fixed_color_clusters(labels,img,mix_pos, begin_idx,clu_meth_name,no,newfolder,foldername)
num_pic = length(img);
sub =  2;
begin_idx=[begin_idx;length(labels)+1];
[height,width,~]= size(img{1});
% figure(num_pic);  % define figure
% scrsz = get(0,'ScreenSize');
% set(gcf,'Position',scrsz);

for i=1: ceil(num_pic/sub^2)
    figure;
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',scrsz);
    for ii = 1: sub^2
        if 4*i-5+ii<num_pic
            subplot(sub,sub,ii);
            pos =mix_pos{4*i-4+ii};
            cluster = labels(begin_idx(4*i-4+ii):begin_idx(4*i-4+ii+1)-1);
            pic=zeros(height,width)-1;
            %             unqValues = unique(labels);
            for j=1:length(pos)
                point=pos{j};
                [num,~]=size(point);
                for jj=1:num
                    pic(point(jj,2),point(jj,1))=cluster(j);
                end
            end
            pic_color=img{4*i-4+ii};
            clmap=colormap(jet(length(no)));
            A=(0:length(no)-1)/length(no)+1/(length(no)*2);
            for j = 1:length(no)
                [row,col] = find(pic==no(j));
                for k = 1: length(row)
                    pic_color(row(k),col(k),:)=clmap(j,:)*255;
                end
            end
            image(pic_color);
            colorbar('Ticks',A,'TickLabels',no);
            axis off
        end
    end
    suptitle([clu_meth_name, num2str(no)]);
    % suptitle([clu_meth_name,'  cell clusters on plaques']);
    directory = [newfolder,'\results\',foldername,filesep,clu_meth_name,filesep];
    if ~exist(directory,'dir')
        mkdir(directory);
    end
    print(gcf,'-dpng',[directory,num2str(no),'_',num2str(i),' clusters.jpg']);
end
end


