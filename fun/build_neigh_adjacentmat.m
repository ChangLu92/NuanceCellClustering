function [neigh_adj_mat, dist_mat,centroids] = build_neigh_adjacentmat(img,pos,flag)
%  get centroid
L=zeros(size(img,1),size(img,2));
for i=1:length(pos)
    posi=pos{i};
    if isempty(find(posi<0, 1))&& size(posi,1)<2000
        for j=1:size(posi,1)
            L(posi(j,2),posi(j,1))=i;
        end
    end
end
stats = regionprops(L,'centroid');
centroids = cat(1, stats.Centroid);

centroids2 = centroids(~isnan(centroids(:,1)),:);

%   Delaunay Triangulation and get neighbours
tri = delaunayTriangulation(centroids2(:,1), centroids2(:,2));

if flag==1
    figure; imshow(img)
    hold on,
    plot(centroids(:,1), centroids(:,2), 'y*'); hold on,
    triplot(tri,'color','g'); hold off
end
num_cell=size(centroids,1);
neigh_adj_mat = zeros(num_cell,num_cell);
dist_mat = pdist2(centroids,centroids);
jj = 1;
for ii=1:size(centroids,1)
    if ~isnan(centroids(:,1))
        v = vertexAttachments(tri,jj);
        neigh_idx=unique(tri.ConnectivityList(v{:},:));
        neigh_idx(neigh_idx==ii)=[];
        neigh_adj_mat(ii,neigh_idx)=1;
        jj = jj+1;
    end
end

dist_mat = dist_mat.*neigh_adj_mat;
dist_mat = sparse(dist_mat);
 
neigh_adj_mat=sparse(neigh_adj_mat);
end
