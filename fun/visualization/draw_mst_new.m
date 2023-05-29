function h = draw_mst_new(labels,centers,similarity,color, shownum )

% not useful
% labels,
% centers,
% similarity,
% superlabels
% color

sim = pdist(centers,similarity);
sim = squareform(sim);
G = sparse(sim);
A = graph(G);
[mst_tree,pred] = minspantree(A,'Method','sparse');


unqValues = unique(labels);
if( isempty(color))
  color = distinguishable_colors(numel(unqValues));
end
unq_Node_size=5:0.5:5+(length(unqValues)-1);
num_cell=zeros(size(mst_tree.Nodes,1),1);
for k=1:size(mst_tree.Nodes,1)
    num_cell(k)=length(find(labels==unqValues(k)));
end
[val,~]=sort(num_cell);
node_size=zeros(size(mst_tree.Nodes,1),1);
for k=1:size(mst_tree.Nodes,1)
    a=unq_Node_size(val==num_cell(k));
    if length(a)~=1
        a=a(1);
    end
    node_size(k)=a;
end

h= plot(mst_tree,'Layout','force');
h.NodeColor = color;
h.MarkerSize = node_size;
h.NodeFontSize = 13;

coeff = zeros(size(mst_tree.Nodes,1),2);
coeff(:,1) = h.XData;
coeff(:,2) = h.YData;

if (shownum == 'T')
for k=1:size(coeff,1)
% %     text(coeff(1,k)+0.25, coeff(2,k), num2str(unqValues(k)), 'FontSize', 14 ,'Color','black','FontWeight','Bold','FontAngle','italic','BackgroundColor','none','Margin',1);
    text(coeff(k,1)-0.2, coeff(k,2)+0.2, num2str(length(find(labels==unqValues(k)))), 'Color','red','FontSize', 12);
end
end

axis off
end

