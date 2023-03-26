%%  After cell segmentation on Qupath, and obtaining ROI files, this
% program will generate a cell-Nuance intensity matrix and a cooradinates
% get cell-nuance intensity matrix of each plaque
% Author: Chang Lu
% c.lu@maastrichtuniversity.nl

nuancenameFolds = fileNames;
nuancefolder = datapath;

% q = dir([nuancefolder, filesep,nuancenameFolds{1},filesep,'*.tif']);
% pic = {q.name}';
% pic = extractBefore(pic,'.tif');
% pic(ismember(pic,'HE')) = [];
% pic(ismember(pic,nucleipic)) = [];

numfea=length(pic);
for jj=1:length(nuancenameFolds)
    jjfolder=[nuancefolder,filesep,nuancenameFolds{jj}];
    %         jjfolder = newfolder;
    %         if exist([jjfolder,filesep,'cellintensity.mat'],'file')
    %             continue;
    %         end
    if ~exist([jjfolder,filesep,'RoiSet'],'dir')
        continue;
    end
    dirOutput=dir(fullfile(jjfolder,filesep,'RoiSet',filesep,'*'));
    numcell = length(dirOutput)-2;
    aveintensity=zeros(numcell,numfea);
    pos=[];
    posroi=[];

    for kk=1:length(pic)
        nucleus_img_name=[jjfolder,filesep,pic{kk}, '.tif'];
        im=imread(nucleus_img_name);
        mysize=size(im);
        if numel(mysize)>2
            im=rgb2gray(im);
        end
        im=im';
        for i=1:numcell %number of cells
            stri=num2str(i);
            name=[jjfolder,filesep,'RoiSet',filesep,dirOutput(i+2).name];
            [sROI] = ReadImageJROI(name);
            if ~isfield(sROI,'mnCoordinates') 
                sROI.strName;
                continue;
            end
            %                 regionpoints=sROI.mnCoordinates;
            %                 BW = poly2mask(regionpoints(:,1),regionpoints(:,2),size(im,1),size(im,2));
            %                 aveintensity(i,kk)=sum(sum(im.*uint8(BW)))/sum(sum(uint8(BW)));
            %
            %                 if kk==1
            %                     [x,y]=find(BW==1);
            %                     pos{i}=[x,y];
            %                     posroi{i}=regionpoints;
            %                 end
            
            regionpoints=[sROI.mnCoordinates;sROI.mnCoordinates(1,:)];
            
            regionpoints(regionpoints(:,1)>mysize(2),1) = mysize(2);
            regionpoints(regionpoints(:,2)>mysize(1),2) = mysize(1);
            
            top=sROI.vnRectBounds(1);
            left=sROI.vnRectBounds(2);
            bottom=sROI.vnRectBounds(3);
            right=sROI.vnRectBounds(4);
            
            point=[];
            for k=0:bottom-top
                p=repmat(top+k,right-left+1,1);
                point= [point;p];
            end
            point(:,2)=point;
            y=left:right;
            point(:,1)=repmat(y',bottom-top+1,1);
            %                                 in = inROI(regionpoints, point(:,1),point(:,2));
            in=inpolygon(point(:,1),point(:,2),regionpoints(:,1),regionpoints(:,2));
            pointsin=point.*in;
            pointsin(find(pointsin(:,1)==0),:)=[];
            pointsin(find(pointsin(:,2)==0),:)=[];
            intensity=zeros(length(pointsin),1);
            [num,~]=size(pointsin);
            for j=1:num
                intensity(j,1)=im(pointsin(j,1),pointsin(j,2));
            end
            aveintensity(i,kk)=sum(intensity)/length(intensity);
            if kk==1
                pos{i}=pointsin;
                posroi{i}=regionpoints;
            end
        end
    end
    aveintensity(isnan(aveintensity))=0;
    idx=[];
    for i=1:length(posroi)
        if length(pos{i})<20
            idx=[idx;i];
        end
    end
    idx
    posroi(idx)=[];
    pos(idx)=[];
    aveintensity(idx,:)=[];
    
    filename= [jjfolder,filesep,'cellintensity'];
    save([filename,'.mat'],'aveintensity','pic','pos','posroi');
    T = array2table(aveintensity);
    T.Properties.VariableNames = matlab.lang.makeValidName(pic);
    writetable(T,[filename,'.xls']);
end
sprintf('getCellNuanFeaMat is done!')