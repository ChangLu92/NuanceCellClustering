function centers = getCenters(cluster,X)
% get mean of each cluster
c_name = unique(cluster);
centers = zeros(length(c_name),size(X,2));

if iscell(c_name)
   for ii = 1: length(c_name)
    if sum(strcmp(cluster , c_name{ii}))==1
        centers(ii,:)=X(strcmp(cluster , c_name{ii}),:);
    else
        centers(ii,:) = median(X(strcmp(cluster , c_name{ii}),:));
    end
   end 
else

for ii = 1: length(c_name)
    if sum(cluster == c_name(ii))==1
        centers(ii,:)=X(cluster == c_name(ii),:);
    else
        centers(ii,:) = median(X(cluster == c_name(ii),:));
    end
end
end 