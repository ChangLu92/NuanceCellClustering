% 1. get all nucleis by superpixels
% 2. overlay nucleis with cell segments
% 3. find ki67+ cells and label them
% 4. save nucleis size and maximal and average intensity.



% alternative set of standard values (HDAB from Fiji)
He = [ 0.6500286;  0.704031;    0.2860126 ];
DAB = [ 0.26814753;  0.57031375;  0.77642715];
Res = [ 0.7110272;   0.42318153; 0.5615672 ]; % residual
% combine stain vectors to deconvolution matrix
HDABtoRGB = [He/norm(He) DAB/norm(DAB) Res/norm(Res)]';
RGBtoHDAB = inv(HDABtoRGB);



nuancenameFolds = fileNames;
nuancefolder = datapath;

for jj=1:length(nuancenameFolds)
        jjfolder=[nuancefolder,filesep,nuancenameFolds{jj}];
        nuanceimg = imread([jjfolder,filesep,'HE.jpg']);
        load([jjfolder,filesep,'cellintensity.mat']);
        I = rgb2gray(nuanceimg);
        
        mask1 = zeros(size(nuanceimg,1),size(nuanceimg,2));
        mask1 = logical(mask1);
        labelmask = zeros(size(nuanceimg,1),size(nuanceimg,2));
        for i = 1:length(posroi)
            pr = posroi{i};
            BW = poly2mask(pr(:,1),pr(:,2),size(nuanceimg,1),size(nuanceimg,2));
            labelmask = labelmask + (labelmask==0).*(double(BW)*i);
%             unique(labelmask)
            mask1 = BW | mask1;
        end
%         figure;
%         imshow(mask1)
        
        % color deconvolution
        % separate stains = perform color deconvolution
        tic
        imageHDAB = SeparateStains(nuanceimg, RGBtoHDAB);
        toc
        
%         for i = 1:3
%             figure;
%             imshow(imageHDAB(:,:,i));
%         end
        
        newimg = imageHDAB(:,:,1);
%         bw = imbinarize(newimg, graythresh(newimg));
        bw = imbinarize(newimg, 'adaptive','ForegroundPolarity','dark','Sensitivity',0.4);
        bw = ~bw;
%         figure; imshow(bw)

%         mask_perim = bwperim(mask1);
%         overlay1 = imoverlay(bw, mask_perim, [.3 1 .3]);
%         overlay2 = imoverlay(newimg, mask_perim, [.3 1 .3]);
%         figure;imshowpair(overlay1, overlay2,'montage' );        
        
%         mask_em =  imregionalmin(newimg,4);
%         overlay3 = imoverlay(mask_em, mask_perim, [.3 1 .3]);
%         figure;imshowpair(overlay3,newimg)
        
        
        
%         bw2 = imfill(bw,'holes');
%         bw3 = imopen(bw2, ones(5,5));
%         bw4 = bwareaopen(bw3, 40);
%         bw4_perim = bwperim(bw4);
%         overlay1 = imoverlay(I_eq, bw4_perim, [.3 1 .3]);
%         imshow(overlay1)



        
        graynuclei = imageHDAB(:,:,3);         
        cleanimg = mask1.*graynuclei;
        
        mask_em = imregionalmax(cleanimg,4);
%         figure; imshow(mask_em);
        BW2 = bwareaopen(mask_em,2);
        overlay2 = imoverlay(cleanimg, BW2, [.3 1 .3]);
        imshow(overlay2)
        
        vec_cleanimg = cleanimg(:);
        
%         figure;
%         histogram(vec_cleanimg(vec_cleanimg~=0));
        
%         figure;
%         imshowpair(graynuclei,cleanimg,'montage'); 


               
%         showimgboundary(posroi,bw); 






%% find ki67+ cells and save it

    % find nuclei by imerode
        SE = strel('disk',5,4);
        BW2 = imerode(cleanimg,SE); 
        bw = imbinarize(BW2,0);

        figure;
        imshowpair(bw,BW2,'montage');

        ki67img = imread([jjfolder,filesep,ki67pic,'.tif']);
        bw_KI67 = imbinarize(ki67img, 0.2);

%         figure;
%         imshow(bw_KI67)
%         
        SE = strel('diamond',1);
        openki67 = imopen(bw_KI67,SE);
%         figure;
%         imshowpair(bw_KI67,openki67,'montage')
        
        CC = bwconncomp(openki67);
        stats = regionprops(CC,'PixelList');
        value = regionprops(CC,ki67img,'PixelValues');
        maxidx = zeros(length(stats),1);
        new_mask = zeros(size(nuanceimg,1),size(nuanceimg,2));        
        for j=1:length(stats)
            y = stats(j).PixelList(:,1);
            x = stats(j).PixelList(:,2);
            v = value(j).PixelValues;
            maxidx = find(v==max(v));
            for k = 1:length(maxidx)
                new_mask(x(maxidx(k)),y(maxidx(k)))=1;
            end
        end
        poski67 = zeros(length(pos),1);
        
        intersect_mask = bw & new_mask;
        savepath=[jjfolder,filesep];
        figure;
        imshowpair(bw,ki67img);
        print(gcf,'-djpeg',[savepath,'overlayki67.jpg']);
        figure; imshow(intersect_mask);
        print(gcf,'-djpeg',[savepath,'ki67+.jpg']);       
        close all;
        
        cellidx = unique(intersect_mask.*labelmask);
        cellidx(cellidx==0)=[];
        poski67(cellidx)=1;
        save([savepath,'poski67.mat'],'poski67');
 
end

