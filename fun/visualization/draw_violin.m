function draw_violin(labels,inten,markername,clu_meth_name,b,directory)
unqValues = unique(labels);
num_c=length(unqValues);
num_f=size(inten,2);
% row =  ceil(sqrt(num_c));
color = distinguishable_colors(numel(1:num_f));

sub =  2;
for i=1: ceil(num_c/sub^2)
    figure;  % define figure
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',scrsz);
    for ii = 1: sub^2
        if 4*i-5+ii<num_c
            subplot(sub,sub,ii);
            x=unqValues(4*i-4+ii);
            idx=find(labels==x);
            % violin(inten(idx,:),'xlabel',markername,'facecolor',color,'edgecolor','b',...
            % 'bw',0.3,'mc','k')
            violin(inten(idx,:),'xlabel',markername,'facecolor',color,'bw',b);
            n = num2str(unqValues(4*i-4+ii));
            title(n);
        end
    end
    suptitle([clu_meth_name,' violin plot']);
%     directory = [newfolder,'\results\',foldername,filesep,clu_meth_name,filesep];
%     if ~exist(directory,'dir')
%         mkdir(directory);
%     end
    print(gcf,'-dpng',[directory,num2str(i),'_','violin plot.jpg']);
end
end