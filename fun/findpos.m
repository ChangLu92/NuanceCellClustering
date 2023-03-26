function pos_new=findpos(posroi)
% find positions of every cell by ROI
pos_new=[];
for ii=1:length(posroi)
    posi=posroi{ii};
    posi=round(posi);
    top=min(posi(:,1));
    left=min(posi(:,2));
    bottom=max(posi(:,1));
    right=max(posi(:,2));
    
    point=[];
    for k=0:bottom-top
        p=repmat(top+k,right-left+1,1);
        point= [point;p];
    end
    point(:,1)=point;
    y=left:right;
    point(:,2)=repmat(y',bottom-top+1,1);
    in=inpolygon(point(:,1),point(:,2),posi(:,1),posi(:,2));
    pointsin=point.*in;
    pointsin(find(pointsin(:,1)==0),:)=[];
    pointsin(find(pointsin(:,2)==0),:)=[];
    pos_new{ii}=pointsin;
end
end