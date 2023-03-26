function draw_tsne_on_each_cluster(tsne,label,clu_meth_name,newfolder,foldername)
global clr
vX = tsne(:,1);
vY = tsne(:,2);
unqValues = unique(label);
for i=1:length(unqValues)
    new_labels=label;
    new_labels(label~=unqValues(i))=-1;
    new_clr=[0 0 0; clr(i,:)];
    vColor = new_labels;
    vColor_discrete = vColor;
    colors = unique(vColor)';
    %     unqValues = unique(vColor);
    vZ = vColor;
    for ci=1:numel(colors)
        vColor_discrete(vColor==colors(ci)) = ci;
    end
    
    % plot
    figure;
    set(gcf,'Position',[100 100 800 700]);
    myplotclr(vX, vY, vZ, vColor_discrete, 'o', new_clr, [min(vColor_discrete), max(vColor_discrete)], false)
    legend(num2str(colors'),'Location','eastoutside');
    colorbar off;
    title([clu_meth_name,'  tsne']);
    directory = [newfolder,'\results\',foldername,filesep,clu_meth_name,filesep];
    % directory=[cd,str,'\'];
    if ~exist(directory,'dir')
        mkdir(directory);
    end
    print(gcf,'-dpng',[directory,'tsne',num2str(unqValues(i)),'.jpg']);
end
end

