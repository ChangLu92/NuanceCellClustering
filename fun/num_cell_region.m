function [mat,plaques, regions] = num_cell_region(labels,nuancedatacell)
%NUM_CELL_REGION calculate the number of cells of each cluster in differnt
%regions
%   Detailed explanation goes here
combinemat=[nuancedatacell.plaquename,nuancedatacell.region];
uninuancedatacell=unique(combinemat,'rows');
uninuancedatacell(uninuancedatacell(:,2)=="",:)=[];
plaques=uninuancedatacell(:,1);
regions=uninuancedatacell(:,2);
mat=zeros(size(uninuancedatacell,1),length(unique(labels)));
for i = 1:size(uninuancedatacell,1)
    idx=combinemat==uninuancedatacell(i,:);
    labeli=labels(sum(idx,2)==2);
    B=tabulate(labeli);
    mat(i,B(:,1))=B(:,2);
end
end

