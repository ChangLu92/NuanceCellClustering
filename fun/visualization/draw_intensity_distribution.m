function draw_intensity_distribution(labels,inten,markername,clu_meth_name,newfolder)
unqValues = unique(labels);
num_c=length(unqValues);
num_f=size(inten,2);
row =  ceil(sqrt(num_c));
color = distinguishable_colors(numel(1:num_f));
figure(num_c);  % define figure
set(gcf,'Position',[100 100 1500 1000]);
for ii = 1: num_c
    subplot(row,row,ii);
    x=unqValues(ii);
    idx=find(labels==x);
    for kk = 1: num_f
        scatter(repmat(kk,length(idx),1),inten(idx,kk),3,color(kk,:),'filled');
        hold on;
    end
    if ii == 1
        legend(markername,'FontSize',10,[10, 100, 130, 520]);
    end
    n = num2str(unqValues(ii));
    title(n);
    hold off;
end
suptitle([clu_meth_name,'  distribution']);
directory = [newfolder,'\results\','cellbiomarker_integration',filesep,clu_meth_name,filesep];
if ~exist(directory,'dir')
    mkdir(directory);
end
print(gcf,'-dpng',[directory,'distribution.jpg']);
end

