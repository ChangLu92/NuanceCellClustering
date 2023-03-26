function centers = getCenters(cluster,X)
% get mean of each cluster
c_name = unique(cluster);
centers = zeros(length(c_name),size(X,2));
for ii = 1: length(c_name)
    if sum(cluster == c_name(ii))==1
        centers(ii,:)=X(cluster == c_name(ii),:);
    else
        centers(ii,:) = median(X(cluster == c_name(ii),:));
    end
end