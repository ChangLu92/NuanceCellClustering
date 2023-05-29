function p = aveinten_onMST(fileNames,datapath, bio_name, mix_pos, labels)
%AVEINTEN_ONMST Summary of this function goes here
%   Detailed explanation goes here
meanint = [];
for jj=1:length(fileNames)   
        nucleus_img_name=[datapath, filesep,fileNames{jj},filesep,bio_name, '.tif'];
        im=imread(nucleus_img_name);
        mysize=size(im);
        if numel(mysize)>2
            im=rgb2gray(im);
        end
        im=im';
        pos = mix_pos{jj};
        aveint = zeros(length(pos),1);
        for i=1:length(pos)%number of cells
            pointsin = pos{i};
            intensity=zeros(length(pointsin),1);
            [num,~]=size(pointsin);
            for j=1:num
                intensity(j,1)=im(pointsin(j,1),pointsin(j,2));
            end
            aveint(i)=sum(intensity)/length(intensity);
        end
        meanint = [meanint; aveint];
end
p = getmedian(meanint, labels);  

end

