function draw_network(labels,similairity,centers,clu_meth_name,newfolder,foldername,kk)
global clr
% network
kgraph=zeros(size(centers,1),size(centers,1));
dist=pdist2(centers,centers,similairity);
for ii=1:length(dist)
    [b,idx]=sort(dist(ii,:));
    kgraph(ii,idx(2:kk+1))= dist(ii,idx(2:kk+1));
end
G = digraph(kgraph);
Names = unique(labels);
a=G.Edges.Weight/max(G.Edges.Weight);
[LWidths,~] = mapminmax(a',0.5,7);
% G = simplify(G,'max');

figure;
set(gcf,'Position',[100 100 800 800]);

% subplot(1,2,1);
p = plot(G,'Layout','force','LineWidth',LWidths,'NodeLabel',Names,'Marker','.');
unq_Node_size=5:1:5+(length(Names)-1);
num_cell=zeros(length(Names),1);
for k=1:length(Names)
    num_cell(k)=length(find(labels==Names(k)));
end
[val,~]=sort(num_cell);
node_size=zeros(length(Names),1);
for k=1:length(Names)
    a=unq_Node_size(val==num_cell(k));
    if length(a)~=1
        a=a(1);
    end
    node_size(k)=a;
end
p.MarkerSize = node_size*1.2;
p.NodeCData = Names;
colormap(clr)
title([clu_meth_name,' knngraph k=',num2str(kk)]);

% subplot(1,2,2);
% p2 = plot(G,'Layout','force','LineWidth',LWidths,'NodeLabel',Names,'Marker','.');
% bins = conncomp(G);
% p2.MarkerSize = node_size*4;
% p2.NodeCData = bins;
% colormap(hsv)
% title([clu_meth_name,' strongly connected components']);


% hold on;
% unqValues = Names;
% unq_Node_size=5:1:5+(length(unqValues)-1);
% num_cell=zeros(length(unqValues),1);
% for k=1:length(unqValues)
%     num_cell(k)=length(find(labels==unqValues(k)));
% end
% [val,~]=sort(num_cell);
% node_size=zeros(length(unqValues),1);
% for k=1:length(unqValues)
%     a=unq_Node_size(val==num_cell(k));
%     if length(a)~=1
%         a=a(1);
%     end
%     node_size(k)=a;
% end
% for k=1:length(unqValues)
%     %     text(p.XData(k)+0.2, p.YData(k), num2str(unqValues(k)), 'FontSize', 10,'Color','red','FontWeight','Bold');
%     text(p.XData(k), p.YData(k)+0.2, num2str(length(find(labels==unqValues(k)))), 'FontSize', 10, 'Color','red','FontWeight','Bold');
% end
% for k=1:length(unqValues)
%     plot(p.XData(k),p.YData(k),'o','markersize',node_size(k), 'color',clr(k,:), 'markerfacecolor',clr(k,:),'markeredgecolor',clr(k,:));
% end
% axis off
% title([clu_meth_name,' knngraph k=',num2str(kk)]);

directory = [newfolder,'\results\',foldername,filesep,clu_meth_name,filesep];
if ~exist(directory,'dir')
    mkdir(directory);
end
print(gcf,'-dpng',[directory,' knngraph k=',num2str(kk),'.jpg']);


% % dist = 1-squareform(dist);
% kgraph=dist-eye(length(dist));
% % for ii=1:length(dist)
% %     [b,idx]=sort(dist(ii,:));
% %     kgraph(ii,idx(2:k+1))= dist(ii,idx(2:k+1));
% % end
% % t=min(max(kgraph));
% kgraph(dist<t)=0;
% kgraph=sparse(kgraph);
% % name = convertCharsToStrings(name');
% G = graph(kgraph,'omitselfloops');
% Names = unique(labels');
% a=G.Edges.Weight/max(G.Edges.Weight);
% [LWidths,~] = mapminmax(a',0.5,8);
% figure;
% set(gcf,'Position',[100 100 1000 900]);
% % plot(G,'EdgeLabel',G.Edges.Weight,'LineWidth',LWidths);
% p = plot(G,'LineWidth',LWidths,'NodeLabel',Names,'Marker','.','MarkerSize',30);
% hold on;
% % p.NodeCData = clr;
% % p.NodeColor = clr;
% unqValues = unique(labels);
% unq_Node_size=5:1:5+(length(unqValues)-1);
% num_cell=zeros(length(unqValues),1);
% for k=1:length(unqValues)
%     num_cell(k)=length(find(labels==unqValues(k)));
% end
% [val,~]=sort(num_cell);
% node_size=zeros(length(unqValues),1);
% for k=1:length(unqValues)
%     a=unq_Node_size(val==num_cell(k));
%     if length(a)~=1
%         a=a(1);
%     end
%     node_size(k)=a;
% end
% for k=1:length(unqValues)
%     %     text(p.XData(k)+0.2, p.YData(k), num2str(unqValues(k)), 'FontSize', 10,'Color','red','FontWeight','Bold');
%     text(p.XData(k), p.YData(k)+0.2, num2str(length(find(labels==unqValues(k)))), 'FontSize', 10, 'Color','red','FontWeight','Bold');
% end
% for k=1:length(unqValues)
%     plot(p.XData(k),p.YData(k),'o','markersize',node_size(k), 'color',clr(k,:), 'markerfacecolor',clr(k,:),'markeredgecolor',clr(k,:));
% end
% axis off
% title([clu_meth_name,'  kgraph']);
% directory = [newfolder,'\results\','cellbiomarker_integration',filesep,clu_meth_name,filesep];
% if ~exist(directory,'dir')
%     mkdir(directory);
% end
% print(gcf,'-dpng',[directory,'kgraph.jpg']);
end

