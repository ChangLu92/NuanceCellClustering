
function draw_boxplots(labels,inten,markername,clu_meth_name,newfolder)
row =  2;
unqValues = unique(labels);
num_c=length(unqValues);
num_f=size(inten,2);
% row =  ceil(sqrt(num_c));
color = distinguishable_colors(numel(1:num_f));
for ii = 1: ceil(num_c/(row*row))
    figure;  % define figure
    set(gcf,'Position',[100 100 1500 1000]);
    for i=1:row*row
        if i+(ii-1)*row*row<num_c+1
            subplot(row,row,i);
            x=unqValues(i+(ii-1)*row*row);
            idx=find(labels==x);
            boxplot(inten(idx,:),markername,'color',color);
            n = num2str(unqValues(i+(ii-1)*row*row));
            title(n);
            xlabel('biomarkers')
            ylabel('intensities')
        end
    end
    suptitle([clu_meth_name,'  boxplots']);
    directory = [newfolder,'\results\','cellbiomarker_integration',filesep,clu_meth_name,filesep];
    if ~exist(directory,'dir')
        mkdir(directory);
    end
    print(gcf,'-dpng',[directory,num2str(ii),'_boxplots.jpg']);
end
end

