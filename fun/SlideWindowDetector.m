function best_region = SlideWindowDetector( I ,Template, windowsize, step, top)
[n, m] = size(I);

h=windowsize(1);
w=windowsize(2);
wid_step = round(w/step);
ht_step = round(h/step);
[optimizer, metric] = imregconfig('multimodal');
optimizer.InitialRadius = optimizer.InitialRadius/4;
optimizer.MaximumIterations = 300;

% ii=1;
hts=1 : ht_step : (n-windowsize(1));
wids=1 : wid_step : (m-windowsize(2));
MI=zeros(length(hts), length(wids));
BoundingBox=zeros(length(hts), length(wids),4);


for i=1:length(hts)
    for j=1:length(wids)
        tmp_img = I(hts(i):hts(i)+h-1, wids(j):wids(j)+w-1, :);
        MI(i,j) = mutualinfo(tmp_img,Template);
        left = wids(j);
        right = wids(j)+w-1;
        upper = hts(i);
        bottom = hts(i)+h-1;
        BoundingBox_tmp = [left, right, upper, bottom];
        BoundingBox(i,j,:) = BoundingBox_tmp;
    end
end
% delete(gcp('nocreate'))
[r,c] = sort_a_matrix(MI, top);
% [a,b]=find(MI==max(max(MI)));

if isempty(gcp('nocreate'))
    parpool('local',5);
end
parfor ii=1:top
    region_ii=BoundingBox(r(ii),c(ii),:);
    region_ii=squeeze(region_ii);
    region_ii=region_ii+[-50, 50, -50, 50]';
    region_ii(region_ii<1)=1;
    if region_ii(2)>m
        region_ii(2)=m;
    end
    if region_ii(4)>n
        region_ii(4)=n;
    end
    image= I(region_ii(3):region_ii(4),region_ii(1):region_ii(2));
    movingRegistered = imregister(Template, image, 'similarity', optimizer, metric);
    MI_new(ii) = mutualinfo(movingRegistered,image);
    t=[' ii= ' num2str(ii) ];
    disp(t)
end
delete(gcp('nocreate'))

idx=find(MI_new==max(MI_new));
best_region=BoundingBox(r(idx),c(idx),:);
best_region=squeeze(best_region);
best_region=best_region+[-100, 100, -100, 100]';
best_region(best_region<1)=1;
if best_region(2)>m
    best_region(2)=m;
end
if best_region(4)>n
    best_region(4)=n;
end
end


function [r,c] = sort_a_matrix(X, max_number)
[m,n]=size(X);
% max_number=10;
max_value=sort(reshape(X,1,m*n),'descend');
max_value=max_value(1:max_number);
% max_site(m,n)=zeros
for i=1:max_number
    [r(i),c(i)]=find(X==max_value(i));
end
end
