function ms_pos=tranformtoMScoordinate(pos,co_ms,R)
pos_world=zeros(size(pos));
ms_pos=zeros(size(pos));
[pos_world(:,1), pos_world(:,2)] = transformPointsForward(R,pos(:,1),pos(:,2));
% [pos_world(:,1), pos_world(:,2)] = intrinsicToWorld(R,pos(:,1),pos(:,2));
% pos_world = round(pos_world);
% pos_world = pos;
f = 0;
for i = 1:length(pos_world(:,1))
    if ~isnan(pos_world(i,:))
%      [Result,LocResult] = ismember(pos_world(i,:),co_ms(:,1:2),'rows');
     D= pdist2(pos_world(i,:),co_ms(:,1:2));
     if min(D)<12
        ms_pos(i,:)=co_ms(D==min(D),3:4);
     else
%          fprintf('position is out of msi image min distance=%d, i = %d\n',min(D), i);
         f=f+1;
     end
     
%       if ~isempty(LocResult)
%           ms_pos(i,:)=co_ms(LocResult,3:4);
%       end
    end
end
fprintf("the number of pixel is %d, the number of pixel out of img is %d \n", i, f);
end