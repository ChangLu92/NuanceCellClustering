function [sep_inten,sep_label,sub_info] = seperatecells_regions(labels,information,inten)
%SEPERATECELLS_REGIONS Summary of this function goes here
%   Detailed explanation goes here
uniregions=unique(information.region);
uniregions(uniregions=="")=[];
% sub_info=cell(length(uniregions),1);
sep_label=cell(length(uniregions),1);
sep_inten=cell(length(uniregions),1);
for i=1:length(uniregions)
   idx=find(information.region==uniregions(i)); 
   sub_info(i) = struct('regionname',strrep(uniregions(i), '"', ''),'plaquename',information.plaquename(idx),'depth',information.depth(idx),'pos',information.pos(idx),'region',information.region(idx));
   sep_label{i}=labels(idx);
   sep_inten{i}=inten(idx,:);
end
end

