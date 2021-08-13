% calculate distance between landmarks on source image after registration and landmarks on
% target image
function landmarks_dist=cal_dist_landmarks(landmarksfile, rawmat)
T = readtable(landmarksfile,'Delimiter','\t');
% fid = fopen(landmarksfile,'r');
landmarks_dist=zeros(size(T,1),1);
for ii=1:size(T,1)
    xs=T.xSource(ii);
    ys=T.ySource(ii);
    xt=T.xTarget(ii);
    yt=T.yTarget(ii);
    source_coordinate=rawmat(xt,yt,:);
    source_coordinate=reshape(source_coordinate,[1 2]);
    landmarks_dist(ii,:)=pdist2([xs ys],source_coordinate);
end
