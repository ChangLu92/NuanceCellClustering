function p = aveinten_onMST_radius(fileNames,datapath, bio_name, mix_pos, radii, labels)
%aveinten_onMST_radius: average intensity per cluster of a biomarker on MST 
%  step 1:  The average intensity of each cell with the center of the cell as the circle and radii as the radius
%   step 2: The average intensity per cluster on the MST

meanint = [];
for jj=1:length(fileNames)
    nucleus_img_name=[datapath, filesep,fileNames{jj},filesep,bio_name, '.tif'];
    im=imread(nucleus_img_name);
    mysize=size(im);
    if numel(mysize)>2
       im=rgb2gray(im);
    end
    im=im';
    [X,Y]=meshgrid(1:mysize(1),1:mysize(2));
    centroids = findcellcentroid(mix_pos{jj}, mysize);
    aveint = zeros(size(centroids,1),1);
for i = 1: size(centroids,1)
    disk_locations=sqrt((X-centroids(i,2)).^2+(Y-centroids(i,1)).^2) <= radii;
    aveint(i) = sum((im & disk_locations),'all' )/sum(disk_locations,'all');
end
    meanint = [meanint; aveint];
    
end
p = getmedian(meanint, labels);
end

