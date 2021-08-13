function draw_merged_clusters(labels,nuancename,mix_pos, begin_idx,clu_meth_name,no,newfolder,directory,clustername)


num_pic = length(nuancename);
sub =  2;
idx=[];
for ii=1:length(no)
    idx_no = find(labels==no(ii));
    idx = [idx;idx_no];
end
begin_idx=[begin_idx;length(labels)+1];
for i=1: ceil(num_pic/sub^2)
    fig=figure;  % define figure
        scrsz = get(0,'ScreenSize');
        set(gcf,'Position',scrsz);
    for ii = 1: sub^2
        if 4*i-5+ii<num_pic
            subplot(sub,sub,ii);
            %             imgi=img{4*i-4+ii};
            imgi=imread([newfolder,filesep,'Nuance',filesep,nuancename{4*i-4+ii},filesep,'HE.jpg']);
            pos =mix_pos{4*i-4+ii};
            new_idx=idx(idx>begin_idx(4*i-4+ii)-1&idx<begin_idx(4*i-3+ii));
            idxi=new_idx-begin_idx(4*i-4+ii)+1;
            new_pos = pos(idxi);
            for jj=1:length(new_pos)
                % red RGB
                px = new_pos{jj};
                [num,~]=size(px);
                for j=1:num 
                    imgi(px(j,2),px(j,1),1)=255;
                    imgi(px(j,2),px(j,1), 2)=0;
                    imgi(px(j,2),px(j,1), 3)=0;
                end
            end
            image(imgi);
            title(nuancename{4*i-4+ii})
            axis off
        end
    end
    k=num2str(no);
    bb=strrep(clu_meth_name,'_','\_'); 
    suptitle([bb, ' ', k]);
    print(gcf,'-dpng',[directory,clustername,'=',num2str(no),'_',num2str(i),'.jpg']);
    close(fig);
end
end

