function showimgresult(posroi, img_compare,n)
if ndims(img_compare)==3
    [h,w,~]=size(img_compare);
else
    [h,w]=size(img_compare);
end
img=zeros(h,w);
img=logical(img);

if isempty(gcp('nocreate'))
parpool(6);
end

parfor ii=1:n
    posi=posroi{ii};
    BW = poly2mask(ceil(posi(:,1)),ceil(posi(:,2)),h,w);
    %     BW = roipoly(img_compare, round(posi(:,1)), round(posi(:,2)));
    img=img|BW;
    ii
    %     for jj=1:size(posi,1)
    %         img(round(posi(jj,2)),round(posi(jj,1)))=1;
    %     end
end

delete(gcp('nocreate'));

figure;
imshowpair(img,img_compare)
end