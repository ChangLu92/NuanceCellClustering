%% add other information
selected_idx=cell(length(fileNames),1);
removed_idx=cell(length(fileNames),1);
begin_idx=ones(length(fileNames),1);

for ii=1:length(fileNames)
    idx=seq(seq<beginidx(ii+1) & seq>=beginidx(ii));
    selected_idx{ii}=idx-beginidx(ii)+1;
    ridx=common_idx(common_idx<beginidx(ii+1) & common_idx>=beginidx(ii));
    removed_idx{ii}=ridx-beginidx(ii)+1;
    begin_idx(ii+1)=length(idx)+begin_idx(ii);
    
    load([datapath,filesep,fileNames{ii},filesep,'cellintensity.mat']);
    pos(removed_idx{ii})=[];
    posroi(removed_idx{ii})=[];
    mix_pos{ii}=pos;
    mix_posroi{ii}=posroi;
end


%% Check batch effect by pca and tsne
sprintf('Check batch effect by pca and tsne');
colors = jet(length(begin_idx)-1);

norm_inten2=zeros(size(norm_inten,1),size(norm_inten,2));
for jj=1:size(norm_inten,2)
    norm_inten2(:,jj) = (norm_inten(:,jj)-mean(norm_inten(:,jj)))/std(norm_inten(:,jj));
end
[coeff,score,latent]=pca(norm_inten2);

foldername = [];
for i = 1:length(begin_idx)-1
    foldername = [foldername;string(repmat(fileNames{i},begin_idx(i+1)-begin_idx(i),1))];
end

figure; gscatter(score(:,1),score(:,2),foldername, colors )
savefig([datapath,filesep,'pca.fig']);


%% save data to mat
begin_idx(end)=[];
nuancename=fileNames;
tsne_cos = tsne(norm_inten,'Algorithm','barneshut' ,'Distance','cosine');

figure; gscatter(tsne_cos(:,1),tsne_cos(:,2),foldername, colors )
savefig([datapath,filesep,'tsne foldername.fig']);

save([datapath,filesep, 'cellmarker_rescale_intergration_t=',num2str(t),'.mat'],'foldername', 'tsne_cos','norm_inten', 'mix_pos', 'selected_idx', 'begin_idx', 'removed_idx','nuancename','biomarkername');

if(exist('i7aad_inten','var'))
   save([datapath,filesep, 'cellmarker_rescale_intergration_t=',num2str(t),'.mat'],'i7aad_inten','-append');
end

fprintf('nuancematcombination is done! \n')
