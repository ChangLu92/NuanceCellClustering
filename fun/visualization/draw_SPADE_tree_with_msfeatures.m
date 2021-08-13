function fig = draw_SPADE_tree_with_msfeatures(labels,centers,similarity,mzinten)
[B,I]=sort(mzinten);
map=flipud(pink(length(mzinten)));

fig = figure;
set(gcf,'Position',[100 100 1000 1000]);
% build MST
sim = pdist(centers,similarity);
sim = squareform(sim);
G = sparse(sim);
[mst_tree,~] = graphminspantree(G);
mst_tree(find(mst_tree~=0))=1;
node_positions = radio_layout(mst_tree,centers');
% clear the plot
%     hold off; plot(0,0,'visible','off'); hold on;
% draw edges
adj = mst_tree;
coeff = node_positions;
% pairs = SPADE_find_matrix_big_element(triu(adj,1),1);
pairs = find_matrix_big_element(adj,1);
vColor = labels;
unqValues = unique(vColor);

edge_begin_end=[];
edge_handle=[];

for k=1:size(pairs,1)
    handle_tmp = line(coeff(1,pairs(k,:)), coeff(2,pairs(k,:)),'color','g');
    edge_handle = [edge_handle; handle_tmp];
    edge_begin_end = [edge_begin_end; pairs(k,:)];
end
hold on;
unq_Node_size=4:0.3:4+(length(unqValues)-1);
num_cell=zeros(size(coeff,2),1);
for k=1:size(coeff,2)
    num_cell(k)=length(find(labels==unqValues(k)));
end
[val,~]=sort(num_cell);
node_size=zeros(size(coeff,2),1);
for k=1:size(coeff,2)
    a=unq_Node_size(val==num_cell(k));
    if length(a)~=1
        a=a(1);
    end
    node_size(k)=a;
end

% draw nodes
node_handle=[];
for k=1:size(coeff,2)
    handle_tmp = plot(coeff(1,k),coeff(2,k),'o','markersize',node_size(k), 'color',map(I==k,:), 'markerfacecolor',map(I==k,:),'markeredgecolor',map(I==k,:));
    node_handle = [node_handle; handle_tmp];
end
colormap(map)
caxis([B(1),B(end)]);

for k=1:size(coeff,2)
    text(coeff(1,k)+0.21, coeff(2,k)-0.22, num2str(unqValues(k)), 'FontSize', 15 ,'Color',[0.4660 0.6740 0.1880],'BackgroundColor','none', 'FontWeight','Bold');
    %     text(coeff(1,k), coeff(2,k)+0.4, num2str(length(find(labels==unqValues(k)))), 'FontSize', 8);
end


c = colorbar;
set(c , 'Position', [0.92 0.1 0.02 0.5], 'Fontsize', 14);

axis off
set(fig,'Color',[1 1 1]);

% if isa(mz,'double')
%     title([clu_meth_name,'  Minimal Spanning Tree on feature ', num2str(mz),' for subCluster ', num2str(n)]);
% %     print(gcf,'-depsc',[directory,'Cluster ',num2str(n),' MST on mz=',num2str(mz),'.eps']);
%     
% else
% %     title(['Percentage of cells are ' mz, 't = ',num2str(t), ' positive on Minimal Spanning Tree']);
% %     title(['Percentage of cells are ' mz, ' positive on Minimal Spanning Tree']);
%     name = [ mz, ' on Minimal Spanning Tree'];
%     bb=strrep(name,'_','\_'); 
%     title(bb);
% %     print(gcf,'-djpeg',[directory,name,'.jpg']);
% %     print(gcf,[directory,name],'-dpdf')
% %     saveas(fig,[directory,name,'.jpg'])
% end

end
