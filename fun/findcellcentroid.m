function [centroids] = findcellcentroid(pos, sizeimg)
%  get centroid
L=zeros(sizeimg(1),sizeimg(2));
for i=1:length(pos)
    posi=pos{i};
    if isempty(find(posi<0, 1))
        for j=1:size(posi,1)
            L(posi(j,2),posi(j,1))=i;
        end
    end
end
stats = regionprops(L,'centroid');
centroids = cat(1, stats.Centroid);
end

