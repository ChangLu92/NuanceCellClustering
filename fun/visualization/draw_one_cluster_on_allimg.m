function draw_one_cluster_on_allimg(labels,nuancename,mix_pos, begin_idx,clu_meth_name,no,newfolder,foldername)
num_pic = length(nuancename);
% sub =  ceil(sqrt(num_pic));
sub =  1;
idx_no = find(labels==no);
begin_idx=[begin_idx;length(labels)+1];
for i=1: ceil(num_pic/sub^2)
    fig=figure;  % define figure
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',scrsz);
    for ii = 1: sub^2
        %         if 4*i-5+ii<num_pic
        subplot(sub,sub,ii);
        imgi=imread([newfolder,filesep,'Nuance',filesep,nuancename{4*i-4+ii},filesep,'HE.jpg']);
        %             imgi=img{4*i-4+ii};
        pos =mix_pos{4*i-4+ii};
        new_idx=idx_no(idx_no>begin_idx(4*i-4+ii)-1&idx_no<begin_idx(4*i-3+ii));
        idxi=new_idx-begin_idx(4*i-4+ii)+1;
        new_pos = pos(idxi);
        for jj=1:length(new_pos)
            % red RGB
            px = new_pos{jj};
            [num,~]=size(px);
            for j=1:num %?????????????
                imgi(px(j,2),px(j,1),1)=173;
                imgi(px(j,2),px(j,1), 2)=255;
                imgi(px(j,2),px(j,1), 3)=47;
            end
        end
        image(imgi);
        title([nuancename{4*i-4+ii},' cluster',num2str(no)])
        axis off
        %         end
    end
    %     k=num2str(no);
    %     suptitle(k);
    %     num_clu = length(unique(labels));
    directory = [newfolder,'\results\',foldername,filesep,clu_meth_name,filesep];
    if ~exist(directory,'dir')
        mkdir(directory);
    end
    %     print(gcf,'-dpng',[directory,nuancename{i},'_',num2str(i),'.jpg']);
    print(gcf,'-dpng',[directory,nuancename{i},'_',num2str(no),'.jpg']);
    close(fig);
end
end
