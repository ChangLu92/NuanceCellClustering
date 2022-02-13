% Alignment of the H&E and multispectral fluorescent images
% requier 3 images: 
% 1. HE image from MSI layer : 
% 2  multispectral fluorescent images
% 3. 7AAD.JPG

% 1 Binarize 7AAD.JPG and H&E from Nuance image;
% 2 image registration between nuance image and H&E image by a sliding window

% output file: trans_nu2he.mat (including the tform data from nuance image
% to h&e image and region positions)

% Chang Lu c.lu@maastrichtuniversity.nl

currentFolder = pwd;
addpath(genpath('fun'));

%% read h&e image and 7aad image (you should change the file path and names to your own name)
plaquepath = ['..',filesep,'data',filesep,'Mouse 10 root 1 plaque 1'];
% he_img=[plaquepath,filesep,'HE.jpg']; % HE image from MSI layer
nu_he_img_name=[plaquepath,filesep,'nuance.tif']; % HE image from multispectral imaging layer
nucleus_img_name=[plaquepath,filesep,'I_7AAD.tif']; 

%% parameters
pxsize=0.5476190448; % per pixel um % per pixel 0.5 um
nu_px=0.5;
nu_he_img=imread(nu_he_img_name);
nu_he_img=imresize(nu_he_img,pxsize/nu_px);
img_nuance=rgb2gray(nu_he_img);
nucleus_img=imread(nucleus_img_name);

%%  Binarize h&e image
img_nuance=255-img_nuance;
bw_img_nuance = adapthisteq(img_nuance);
bw_img_nuance = imclearborder(bw_img_nuance);
bw_img_nuance = wiener2(bw_img_nuance,[5 5]);
bw_img_nuance = im2bw(bw_img_nuance,graythresh(bw_img_nuance)+0.1);
bw2_img_nuance = imfill(bw_img_nuance,'holes');
bw3_img_nuance = imopen(bw2_img_nuance,strel('disk',2));
bw4_img_nuance = bwareaopen(bw3_img_nuance,70);
bw4_img_nuance=double(bw4_img_nuance);
% figure,imshow(bw4_img_nuance);

%%  Binarize nucleus image
nucleus_size=size(nucleus_img);
if numel(nucleus_size)>2
    nucleus_img=rgb2gray(nucleus_img);
end
nucleus_img = imadjust(nucleus_img);
nucleus_img = adapthisteq(nucleus_img);
nucleus_img = imclearborder(nucleus_img);
nucleus_img = wiener2(nucleus_img,[5 5]);
% if graythresh(nucleus_img)-0.3>0
%     bw = im2bw(nucleus_img,graythresh(nucleus_img)+0.3);
% else
%     bw = im2bw(nucleus_img,graythresh(nucleus_img)+0.1);
% end
bw = im2bw(nucleus_img,graythresh(nucleus_img)+0.2);
bw2 = imfill(bw,'holes');
bw3 = imclose(bw2,strel('disk',3));
bw4 = imopen(bw3,strel('disk',4));
%   bw4 = bwareaopen(bw3,20); %Remove small objects from binary image
bw4=double(bw4);

figure; imshow(bw4);

%% initial registration
[optimizer, metric] = imregconfig('multimodal');
optimizer.InitialRadius = optimizer.InitialRadius/3.5;
optimizer.MaximumIterations = 400;
tform = imregtform(bw4, bw4_img_nuance, 'rigid', optimizer, metric);
movingRegistered_he_jj = imwarp(bw4,tform,'OutputView',imref2d(size(bw4_img_nuance)));


figure; imshowpair(movingRegistered_he_jj,bw4_img_nuance); title('Registration')
C = imfuse(movingRegistered_he_jj,img_nuance,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
imshow(C)
imwrite(C,[plaquepath,filesep,'my_blend_red-green.png']);



%% Sliding Window
[nucleus_h,nucleus_w]=size(nucleus_img);
windowsize=[nucleus_h nucleus_w];
step=20;
top=10;
tic;
region = SlideWindowDetector(bw4_img_nuance ,bw4, windowsize, step, top);
toc;

bw_he_img_jj= bw4_img_nuance(region(3):region(4),region(1):region(2));
[optimizer, metric] = imregconfig('multimodal');
optimizer.InitialRadius = optimizer.InitialRadius/4;
optimizer.MaximumIterations = 400;
% movingRegistered = imregister(bw4, image, 'similarity', optimizer, metric);
tform_nu2he = imregtform(bw4, bw_he_img_jj, 'similarity', optimizer, metric);
movingRegistered_he_jj = imwarp(bw4,tform_nu2he,'OutputView',imref2d(size(bw_he_img_jj)));
figure; imshowpair(movingRegistered_he_jj,bw_he_img_jj); title('Registration')


%tranform the h&e image to nuance image size, and finally get a small
% image which has the same size with the nuance image
image= nu_he_img(region(3):region(4),region(1):region(2),:);
invtform = invert(tform_nu2he);
K = imwarp(image,invtform,'OutputView',imref2d(size(bw4)));
figure; imshowpair(K,bw4)
figure; imshowpair(K,nucleus_img)


%% save h&e image and tform data
imwrite(K,[plaquepath,filesep,'HE.jpg']);
save([plaquepath,filesep,'trans_nu2he.mat'], 'tform_nu2he','region');


