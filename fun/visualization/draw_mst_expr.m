function h = draw_mst_expr(labels,centers,similarity,mzinten, logscale, percentage)


%[B,I]=sort(mzinten);

% map=flipud(pink(length(mzinten)));
map=flipud(hot(101));


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

if logscale == true
    logmzinten = log10(mzinten+0.001);
end

for k=1:size(mst_tree.Nodes,1)
    a=unq_Node_size(val==num_cell(k));
    if length(a)~=1
        a=a(1);
    end
    node_size(k)=a;
    if logscale == true
        node_color(k,:) = map(round((logmzinten(k)-min(logmzinten))/(max(logmzinten)-min(logmzinten))*100+1),:);
    else
        node_color(k,:) = map(round((mzinten(k)-min(mzinten))/(max(mzinten)-min(mzinten))*100+1),:);
    end
end


%[~,ind] = sort(I);

f = figure;
h= plot(mst_tree,'Layout','force');
%h.NodeColor = map(ind,:);
h.NodeColor = node_color;
% h.ColorScale = 'log';
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
if percentage == true
    ticklabel(1) = round(min(mzinten),4)*100;
    ticklabel(6) = round(max(mzinten),4)*100;
    for i = 2:5
        ticklabel(i) = ticklabel(1)+round((max(mzinten)-min(mzinten))/5*(i-1),4)*100;
    end
else
    ticklabel(1) = round(min(mzinten),2);
    ticklabel(6) = round(max(mzinten),2);
    for i = 2:5
        ticklabel(i) = round(ticklabel(1)+ (max(mzinten)-min(mzinten))/5*(i-1),2);
    end
end


Ticks = 0:0.2:1;
if logscale == true
    Ticks = rescale(log10(Ticks+0.001),0,1);
end


colormap(f,map);
colorbar('Ticks', Ticks,'TickLabels',ticklabel);
% set(gca,'ColorScale','log')


% colorbar('Ticks', 0:0.2:1,...
%          'TickLabels',ticklabel);





% % preallocate Ticks and TickLabels
% num_of_ticks = 5;
% Ticks      = zeros(1,num_of_ticks);
% TickLabels = zeros(1,num_of_ticks);
% % distribute Ticks and TickLabels
% for n = 1:1:num_of_ticks
%     
%     Ticks(n)      = log10(round(c2)/num_of_ticks*n);
%     TickLabels(n) = round(c2)/num_of_ticks*n;
% end
% % set Ticks and TickLabels
% colorbar('Ticks',Ticks,'TickLabels',TickLabels)


axis off

end


