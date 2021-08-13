function showcellonimg(pos, img_compare)
[h,w]=size(img_compare);
img=zeros(h,w);
% img=logical(img);
for ii=1:length(pos)
    posi=pos{ii};
%       BW = poly2mask(ceil(posi(:,1)),ceil(posi(:,2)),h,w);
%     BW = roipoly(img_compare, round(posi(:,1)), round(posi(:,2)));
%     img=img|BW;
    for jj=1:size(posi,1)
        img(round(posi(jj,2)),round(posi(jj,1)))=1;
    end
end
figure;
imshowpair(img,img_compare)
end