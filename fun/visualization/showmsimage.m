
function showmsimage(reduced_msi_data, xy_positions_new, n, labels)
% show ms image on a specific m/z 
% if labels are not empty, we can also show different cell pythotypes on
% this image
% show labels which are not equal to -1
% n is a vector

max_xy_positions_new=max(xy_positions_new);
msi_data_cube = zeros([max_xy_positions_new(2), max_xy_positions_new(1), size(reduced_msi_data,1)]);
for j=1:size(reduced_msi_data,2)
    msi_data_cube(xy_positions_new(j,2),xy_positions_new(j,1),:) = reduced_msi_data(:,j);
end

if nargin == 3
    for j=1:length(n)
       figure; imagesc(msi_data_cube(:,:,n(j)));colormap jet;
       title(j);
    end
end

if nargin == 4
    idx=find(labels~=-1);
    unqValues = unique(labels(idx));
    clr = distinguishable_colors(numel(unqValues));
    labeltoshow=labels(idx);
    xytoshow=xy_positions_new(idx,:);
    for j=1:length(n)
        label_cube= zeros([max_xy_positions_new(2), max_xy_positions_new(1), 3]);
        for ii=1:length(labeltoshow)
           label_cube(xytoshow(ii,2),xytoshow(ii,1),:) = clr(unqValues==labeltoshow(ii),:);
        end
           figure;
%            subplot(1,2,1);
           a1 = axes;
           h1=imagesc(a1,msi_data_cube(:,:,n));colormap hot; c1 = colorbar;
           h1.AlphaData = .8;
           axis image; hold on
%            subplot(1,2,2);
           a2 = axes; 
           h2 = imagesc(a2,label_cube); c2 = colorbar; axis image;
           a=rgb2gray(label_cube);
           a(a~=0)=1;
           h2.AlphaData = a;
           a1.Visible = 'off';
           a2.Visible = 'off';
           c1.Visible = 'off';
    end    
end