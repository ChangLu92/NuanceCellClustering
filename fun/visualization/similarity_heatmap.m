
function similarity_heatmap(labels,centers,similarity,clu_meth_name,newfolder)
dist=pdist(centers,similarity);
dist = 1-squareform(dist);
unqValues = unique(labels);
xvalues = unqValues;
yvalues = unqValues;
figure;
set(gcf,'Position',[100 100 1500 1200]);
h = heatmap(xvalues,yvalues,dist);
h.Title = [clu_meth_name,'  Similarity'];
h.XLabel = 'Clusters';
h.YLabel = 'Clusters';
directory = [newfolder,'\results\','cellbiomarker_integration',filesep,clu_meth_name,filesep];
if ~exist(directory,'dir')
    mkdir(directory);
end
print(gcf,'-dpng',[directory,'Similarity.jpg']);
end
