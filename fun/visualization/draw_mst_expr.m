function h = draw_mst_expr(labels,centers,similarity,mzinten)


[B,I]=sort(mzinten);

% map=flipud(pink(length(mzinten)));
map=flipud(pink(101));




sim = pdist(centers,similarity);
sim = squareform(sim);
G = sparse(sim);
A = graph(G);
[mst_tree,pred] = minspantree(A,'Method','sparse');


unqValues = unique(labels);
%color = distinguishable_colors(numel(unqValues));

unq_Node_size=5:0.5:5+(length(unqValues)-1);
num_cell=zeros(size(mst_tree.Nodes,1),1);
for k=1:size(mst_tree.Nodes,1)
    num_cell(k)=length(find(labels==unqValues(k)));
end
[val,~]=sort(num_cell);
node_size=zeros(size(mst_tree.Nodes,1),1);
node_color = zeros(size(mst_tree.Nodes,1),3);

for k=1:size(mst_tree.Nodes,1)
    a=unq_Node_size(val==num_cell(k));
    if length(a)~=1
        a=a(1);
    end
    node_size(k)=a;
    node_color(k,:) = map(round((mzinten(k)-min(mzinten))/(max(mzinten)-min(mzinten))*100+1),:);
end

%[~,ind] = sort(I);

f = figure;
h= plot(mst_tree,'Layout','force');
%h.NodeColor = map(ind,:);
h.NodeColor = node_color;
h.MarkerSize = node_size;
h.NodeFontSize = 12;
hold on
coeff = zeros(size(mst_tree.Nodes,1),2);
coeff(:,1) = h.XData;
coeff(:,2) = h.YData;

%for k=1:size(coeff,1)

% % %     text(coeff(1,k)+0.25, coeff(2,k), num2str(unqValues(k)), 'FontSize', 14 ,'Color','black','FontWeight','Bold','FontAngle','italic','BackgroundColor','none','Margin',1);
%     text(coeff(k,1)-0.2, coeff(k,2)+0.2, num2str(length(find(labels==unqValues(k)))), 'Color','red','FontSize', 12);
%end

for i = 1:size(coeff,1)
    plot(coeff(i,1),coeff(i,2),'ko', 'markersize',node_size(i))
    hold on
end
 hold off;


ticklabel = zeros(6,1);
ticklabel(1) = round(min(mzinten),2);
ticklabel(6) = round(max(mzinten),2);
for i = 2:5
    ticklabel(i) = round(ticklabel(1)+ (max(mzinten)-min(mzinten))/5*(i-1),2);
end

colormap(f,map);
colorbar('Ticks', 0:0.2:1,...
         'TickLabels',ticklabel);


axis off

end


