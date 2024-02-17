function overlaymarkerandnuclei(nuancenameFolds,nuancefolder, picname)
    % 1. get all nucleis by superpixels
    % 2. overlay nucleis with cell segments
    % 3. find ki67+ cells and label them
    % 4. save nucleis size and maximal and average intensity.
    % require cellintensity.mat and HE.jpg in folders



    % alternative set of standard values (HDAB from Fiji)
    He = [ 0.6500286;  0.704031;    0.2860126 ];
    DAB = [ 0.26814753;  0.57031375;  0.77642715];
    Res = [ 0.7110272;   0.42318153; 0.5615672 ]; % residual
    % combine stain vectors to deconvolution matrix
    HDABtoRGB = [He/norm(He) DAB/norm(DAB) Res/norm(Res)]';
    RGBtoHDAB = inv(HDABtoRGB);


for jj=1:length(nuancenameFolds)
        jjfolder=[nuancefolder,filesep,nuancenameFolds{jj}];
        nuancenameFolds{jj}
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

        % color deconvolution
        % separate stains = perform color deconvolution
        tic
        imageHDAB = SeparateStains(nuanceimg, RGBtoHDAB);
        toc
     
      
        graynuclei = imageHDAB(:,:,3);         
        cleanimg = mask1.*graynuclei;
        


      %find positive cells and save it

    % find nuclei by imerode
        SE = strel('disk',5,4);
        BW2 = imerode(cleanimg,SE); 
        bw = imbinarize(BW2,0);

        ki67img = imread([jjfolder,filesep,picname,'.tif']);
        bw_KI67 = imbinarize(ki67img, 0.2);

        
        SE = strel('diamond',1);
        openki67 = imopen(bw_KI67,SE);
        
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
        posmarker = zeros(length(pos),1);
        
        intersect_mask = bw & new_mask;
        savepath=[jjfolder,filesep];
        figure;
        imshowpair(bw,ki67img);
        print(gcf,'-djpeg',[savepath,picname,' overlay.jpg']);
        figure; imshow(intersect_mask);
        print(gcf,'-djpeg',[savepath,picname,'.jpg']);       
        close all;
        
        cellidx = unique(intersect_mask.*labelmask);
        cellidx(cellidx==0)=[];
        posmarker(cellidx)=1;
        save([savepath,picname,'.mat'],'posmarker');
 
end


end