function [label_dis_mat,uninuancedatacell] = clusterdistancematrix(labels,depth)
uninuancedatacell=unique(depth);
uninuancedatacell(isnan(uninuancedatacell))=[];
label_dis_mat=zeros(size(uninuancedatacell,1),length(unique(labels)));
for i = 1:size(uninuancedatacell,1)
    idx=depth==uninuancedatacell(i);
    labeli=labels(idx);
    B=tabulate(labeli);
    label_dis_mat(i,B(:,1))=B(:,2);
end
end
