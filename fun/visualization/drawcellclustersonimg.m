function drawcellclustersonimg(posroi, img_compare, n, labels, unqValues, clr)

% draw cell clusters on a given image (h&e or optical)
% cells with no labels are black

if ndims(img_compare)==3
    [h,w,~]=size(img_compare);
else
    [h,w]=size(img_compare);
end

img=zeros(h,w);
img=logical(img);

% if isempty(gcp('nocreate'))
%     parpool(5);
% end

finalimg = zeros(h,w);
for ii=1:n
    posi=posroi{ii};
    BW = poly2mask(ceil(posi(:,1)),ceil(posi(:,2)),h,w);
    img=xor(img,BW);
    no_clr=find(unqValues==labels(ii));
    imgii = ones(h,w)*no_clr;
    imgii=imgii.*BW;
    imgiinew=imgii.*img;
    finalimg=finalimg+imgiinew;
end

pic_color = img_compare;
for j = 1:length(unqValues)
    [row,col] = find(finalimg==j);
    for i = 1: length(row)
        pic_color(row(i),col(i),:)=clr(j,:);
    end
end
image(pic_color);
axis off

% delete(gcp('nocreate'));

end