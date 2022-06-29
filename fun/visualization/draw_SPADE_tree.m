function h = draw_SPADE_tree(labels,centers,similarity,superlabels,color)
% build MST
sim = pdist(centers,similarity);
sim = squareform(sim);
G = sparse(sim);
% [mst_tree,~] = graphminspantree(G);
[mst_tree,~] = minspantree(G);
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


if isempty(superlabels) 
        color = distinguishable_colors(numel(unqValues));
end
% else
%     unisuper = unique(superlabels);
%     if isempty(unicolor)
%         unicolor = distinguishable_colors(numel(unisuper));        
%     end        
%         color = zeros(length(unisuper),3);
%         for i=1:length(unisuper)
%             idx = find(superlabels==unisuper(i));
%             color(idx,:)=repmat(unicolor(i,:),length(idx),1);
%         end
% end
    

% clr = distinguishable_colors(numel(unqValues));
edge_begin_end=[];
edge_handle=[];
h = figure;
set(gcf,'Position',[100 100 1000 1000]);
for k=1:size(pairs,1)
    handle_tmp = line(coeff(1,pairs(k,:)), coeff(2,pairs(k,:)),'color','g');
    edge_handle = [edge_handle; handle_tmp];
    edge_begin_end = [edge_begin_end; pairs(k,:)];
end
hold on;
unq_Node_size=3:0.3:3+(length(unqValues)-1);
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
    handle_tmp = plot(coeff(1,k),coeff(2,k),'o','markersize',node_size(k), 'color',color(k,:), 'markerfacecolor',color(k,:),'markeredgecolor',color(k,:));
    node_handle = [node_handle; handle_tmp];
%     if node_size(k) == max(node_size) || node_size(k) == min(node_size) || node_size(k) == median(node_size)
%        [hleg, hobj, hout, mout] = legend(handle_tmp, num2str(length(find(labels==unqValues(k)))),'FontSize', 12, 'Box','off', 'Position', [0.7 0.7+node_size(k)*0.02 0.15 0.2]);
%        set(get(hobj(2), 'Children'), 'markersize', node_size(k));
%     end
    end

for k=1:size(coeff,2)
    text(coeff(1,k)+0.25, coeff(2,k), num2str(unqValues(k)), 'FontSize', 14 ,'Color','black','FontWeight','Bold','FontAngle','italic','BackgroundColor','none','Margin',1);
%     text(coeff(1,k), coeff(2,k)+0.2, num2str(length(find(labels==unqValues(k)))), 'FontSize', 7);
end

% create_legend_cellsize(node_size, labels, unqValues)
axis off



% title('Minimal Spanning Tree');
% directory = [newfolder,'\results\',foldername,filesep,clu_meth_name,filesep];
% if ~exist(directory,'dir')
%     mkdir(directory);
% end

% print(gcf,'-dpng',[directory,'MST.jpg']);
end



function create_legend_cellsize(node_size, labels, unqValues)

s = zeros(length(unqValues),1);
for i = 1:length(unqValues)
    s(i) = length(find(labels==unqValues(i)));
end

news = round(s/100)*100;

[B,I]=sort(node_size);
sortedS = news(I);

IDX = [1,12,57,68];
nodetoshow = B(IDX);
labeltoshow = sortedS(IDX);

x = 7;
y = [7 8 9 10 11];

for i = 1:length(IDX)
    plot(x,y(i),'o', 'markersize',nodetoshow(i), 'color','black', 'markerfacecolor','black','markeredgecolor','black')
    text(x+0.5, y(i)+0.1, num2str(labeltoshow(i)), 'FontSize', 14 ,'Color','black','BackgroundColor','none','Margin',1);
    hold on
end
 hold off;
%     scatter([2 1 1 1 1],[1 2 3 4 5], 'o',nodetoshow);

end





