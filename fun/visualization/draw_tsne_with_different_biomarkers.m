function draw_tsne_with_different_biomarkers(tsne_re,inten,pic,clu_meth_name,newfolder,foldername)
figure(size(inten,2));  % define figure
scrsz = get(0,'ScreenSize');
set(gcf,'Position',scrsz);
sub =  ceil(sqrt(size(inten,2)));
for ii = 1: size(inten,2)
    subplot(sub,sub,ii);
    %     colormap('pink');
    c = pink;
    c = flipud(c);
    colormap(c);
    scatter(tsne_re(:,1),tsne_re(:,2), 5, inten(:,ii), 'fill');
    colorbar;
    title(pic{ii});
end
suptitle([clu_meth_name,'  tsne with different biomarkers']);
directory = [newfolder,'\results\',foldername,filesep,clu_meth_name,filesep];
% directory=[cd,str,'\'];
if ~exist(directory,'dir')
    mkdir(directory);
end
print(gcf,'-dpng',[directory,'tsne_with_different_biomarkers.jpg']);
end
