
function showSuperClusteronMSIregion(reducedmsi, sp_mz_idx, ms_pos, plaquelabel, labels, figname,clr)
% show MSI image on a specific m/z (sp_mz_idx) on a specific region (in cell_info , e.g. mouse 10 root 2 plaque 1)

max_xy_positions_new=max(ms_pos);
msi_data_cube = zeros([max_xy_positions_new(2), max_xy_positions_new(1)]);


reducedmsi = log(reducedmsi);
rescalemsi=rescale(reducedmsi(sp_mz_idx,:),0.01,1);

% rescalemsi=rescale(reducedmsi(sp_mz_idx,:),0,1);
for j=1:size(reducedmsi,2)
    msi_data_cube(ms_pos(j,2),ms_pos(j,1)) = rescalemsi(j);
end


selectedpos = ms_pos(plaquelabel==1,:);
[L,Il] = max(selectedpos,[],1);
[S,Is] = min(selectedpos,[],1);

newimg = msi_data_cube(S(2):L(2),S(1):L(1));

idx=find(labels~=-1);
unqValues = unique(labels(idx));


labeltoshow=labels(idx);
xytoshow=ms_pos(idx,:);

label_cube= zeros([max_xy_positions_new(2), max_xy_positions_new(1),3]);
for ii=1:length(labeltoshow)
    label_cube(xytoshow(ii,2),xytoshow(ii,1),:) = clr(unqValues==labeltoshow(ii),:);
end
newlabel_cube = label_cube(S(2):L(2),S(1):L(1),:);

figure;
a1 = axes;
h1=imagesc(a1,rot90(newimg,2));colormap gray; 
h1.AlphaData = .8;
axis image; hold on

a2 = axes;
h2 = imagesc(a2,rot90(newlabel_cube,2)); axis image;
a=rgb2gray(rot90(newlabel_cube,2));
a(a~=0)=1;
h2.AlphaData = a;
a1.Visible = 'off';
a2.Visible = 'off';

print(gcf,'-dpng',figname);
end

