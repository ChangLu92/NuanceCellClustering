function [hogfea_fix,BoundingBox]=SlideWindowHoG(I, windowsize, step, num_feature)
[n, m] = size(I);

h=windowsize(1);
w=windowsize(2);
wid_step = round(w/step);
ht_step = round(h/step);

% ii=1;
hts=1 : ht_step : (n-windowsize(1));
wids=1 : wid_step : (m-windowsize(2));
% MI=zeros(length(hts), length(wids));
BoundingBox=zeros(length(hts)*length(wids),4);
hogfea_fix=zeros(length(hts)*length(wids),num_feature);

for i=1:length(hts)
    for j=1:length(wids)
        tmp_img = I(hts(i):hts(i)+h-1, wids(j):wids(j)+w-1, :);
        [hogfea_fix((i-1)*length(wids)+j,:),~] = extractHOGFeatures(tmp_img,'CellSize',[64 64]);
        left = wids(j);
        right = wids(j)+w-1;
        upper = hts(i);
        bottom = hts(i)+h-1;
        BoundingBox_tmp = [left, right, upper, bottom];
        BoundingBox((i-1)*length(wids)+j,:) = BoundingBox_tmp;
    end
    i
end
end
