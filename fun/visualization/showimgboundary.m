function showimgboundary(posroi, img_compare)

figure;
if ndims(img_compare)==3
    imshow(permute(img_compare,[2,1,3]));
else
    imshow(img_compare',[]);
end

% b=[];
hold on
 visboundaries(posroi);
% for ii=1:n
%     hold on
% %     posi=posroi{ii};
% %     c=[];
% %     c(:,1)=posi(:,2);
% %     c(:,2)=posi(:,1);
% %     b = num2cell(c,1);
%     visboundaries(b);
% end
hold off
view(270,270);
end