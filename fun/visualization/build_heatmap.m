
function build_heatmap(labels,begin_idx,clu_meth_name,newfolder,foldername,hename)

% csv file of number of cells in each cluster of each he image
% weight matrix by tfidf
% hierarchical clustering based on cosine distance
% show heatmap

unqValues = unique(labels);
begin_idx=[begin_idx;length(labels)+1];
% percent_cell=zeros(length(begin_idx)-1,length(unqValues));
num_cell_cluster=zeros(length(begin_idx)-1,length(unqValues));
num_cell_pi=zeros(length(begin_idx)-1,length(unqValues));
for ii=1:length(begin_idx)-1
    num_cell_pi(ii,:)=begin_idx(ii+1)-begin_idx(ii);
    %     num_cell_cluster=zeros(1,length(unqValues));
    for jj=1:length(unqValues)
        num_cell_cluster(ii,jj)=length(find(labels(begin_idx(ii):begin_idx(ii+1)-1)==unqValues(jj)));
    end
    %     percent_cell(ii,:)=num_cell_cluster/num_cell_pi;
end
tf_cell=num_cell_cluster./num_cell_pi;
idf_cell=zeros(1,length(unqValues));
for jj=1:length(unqValues)
    idf_cell(jj)=log10(length(hename)/sum(num_cell_cluster(:,jj)~=0));
end

weighted_mat=tf_cell.*repmat(idf_cell,length(begin_idx)-1,1);

xvalues = unqValues;
yvalues = hename;

h = clustergram(weighted_mat,'ColumnLabels',xvalues,'RowLabels',yvalues,'RowLabelsRotate',30,'Cluster','column','RowPDist','cosine');
plot(h);
colorbar;
addTitle(h, [clu_meth_name,'  Heatmap']);
scrsz = get(0,'ScreenSize'); set(gcf,'Position',scrsz);
% h = heatmap(xvalues,yvalues,percent_cell);
% h.Title = [clu_meth_name,'  Heatmap'];
% h.XLabel = 'Clusters';
% h.YLabel = 'Plaques';
directory = [newfolder,'\results\',foldername,filesep,clu_meth_name,filesep];
if ~exist(directory,'dir')
    mkdir(directory);
end
print(gcf,'-dpng',[directory,'Heatmap.jpg']);

T=array2table(num_cell_cluster,'VariableNames',matlab.lang.makeValidName(cellstr(num2str(xvalues))),'RowNames',yvalues);
vTbl = [T table(num_cell_pi(:,1), 'VariableNames', {'numofpositivecell'})];
writetable(vTbl,[directory,'number of cells in each cluster.csv'],'WriteRowNames',true);
end
