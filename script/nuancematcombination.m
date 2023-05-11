% integrate and normalize all cell-biomarker matrix and get t-sne map
% do not normalize on each mouse, just rescale and remove the cells with 
% low intensity (lower than t) on all biomarkers
% Author: Chang Lu
% c.lu@maastrichtuniversity.nl

%% load data 
flag=1;
mix_inten=[];

num_cell=zeros(length(fileNames),1);
beginidx=ones(length(fileNames),1);
for jj=1:length(fileNames)
        load([datapath,filesep,fileNames{jj},filesep,'cellintensity.mat']);        
        num_cell(jj)=size(aveintensity,1);
        size(aveintensity,2)    
        mix_inten = [mix_inten; aveintensity];
        beginidx(jj+1)=num_cell(jj)+beginidx(jj);
end


%%
[a,b]=find(isnan(mix_inten));
if ~isempty(a)
    fprintf('%d %d %d \n',jj,a(1));
end

%% rescale
norm_inten=zeros(size(mix_inten,1),size(mix_inten,2));
for jj=1:size(mix_inten,2)
    norm_inten(:,jj) = rescale(mix_inten(:,jj),0,100);
end

% biomarkername = pic;
% if(sum(ismember(biomarkername,'I_7AAD'))>0)
%     i7aad_inten = norm_inten(:,ismember(biomarkername,'I_7AAD'));
%     norm_inten(:,ismember(biomarkername,'I_7AAD'))=[];
%     biomarkername(ismember(biomarkername,'I_7AAD'))=[];
% end

common_idx=find(max(norm_inten,[],2)<t);
seq=1:size(norm_inten,1);
seq(common_idx)=[];
norm_inten(common_idx,:)=[];
fprintf('%d of %d cells left!',size(norm_inten,1),  size(mix_inten,1));
























