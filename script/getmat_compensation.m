%%get nuancematrix after compensation


nuancenameFolds = fileNames;
nuancefolder = datapath;


for jj=1:length(nuancenameFolds)
        %         if ~exist([nuancefolder,filesep,nuancenameFolds{jj},filesep,'cellintensity.mat'],'file') || exist([nuancefolder,filesep,nuancenameFolds{jj},filesep,'compensatedmat.mat'],'file')
        %             continue;
        %         end
        load([nuancefolder,filesep,nuancenameFolds{jj},filesep,'cellintensity.mat']);
        img=imread([nuancefolder,filesep,nuancenameFolds{jj},filesep,'HE.jpg']);
                showimgboundary(posroi, img);
        [neigh_adj_mat,dist_mat,centroids]=build_neigh_adjacentmat(img,pos,0); % sparse mat (neightbor matrix)(num of cell * num of cell)
        num_cell=length(neigh_adj_mat);
        adj_mat=zeros(num_cell);
        [xDim,yDim,~] = size(img);
        
        mask=zeros(xDim,yDim);
        A=cell(length(posroi),1);
        C=zeros(length(posroi),2);
        X=cell(length(posroi),1);
        
        tic
        figure;
        imshow(img);
        hold on
        for i=1:length(posroi)
            roi=posroi{i};
            [A{i} , C(i,:)] = MinVolEllipse(roi', t);
            x=Ellipse_plot(A{i} , C(i,:));
            X{i}=x';
            BWj = roipoly(img,x(1,:),x(2,:));
            mask=mask|BWj;
        end
        hold off
        
%                 figure;
%                 imshow(img);
%                 for i=1:length(posroi)
%                     hold on
%                     roi=posroi{i};
%                     plot(roi(:,1),roi(:,2),'g-');
%                     hold on
%                     plot(x(:,1),x(:,1),'r-');
%                 end
%                 hold off
        
        over_bw=zeros(xDim,yDim);
        for i=1:num_cell
            idx=find(neigh_adj_mat(i,:)==1);
            if ~isempty(idx)
                roi=posroi{i};
                BW = roipoly(img,roi(:,1),roi(:,2));
                Si= sum(sum(BW));
                %               pgon = polyshape(roi(:,1),roi(:,2));
                for j=1:length(idx)
                    x=X{idx(j)};
                    BWj = roipoly(img,x(:,1),x(:,2));
                    %                  pgonj = polyshape(x(:,1),x(:,2));
                    overlap = and(BW,BWj);
                    %                  polyout = intersect(pgon,pgonj);
                    Sc=sum(sum(overlap));
                    if Sc~=0
                        over_bw = over_bw|overlap;
                        adj_mat(i,idx(j))=Sc/Si;
%                       B = imoverlay(img,BW.*BWj,'yellow');
%                                               figure; imshow(B);
                    end
                end
                Sir=Si-sum(sum(BW.*mask));
                if Sir==0 || Sir <0
                    fprintf('Sir = %d , jj=%d, i= %d \n', Sir,jj,i);
                else
                    adj_mat(i,i)=Sir/Si;
                end
                
%                                  roi_j=posroi{idx(j)};
%                                  c=centroids(idx(j),:);
%                               % display cell i
%                 %               B = imoverlay(img,maski,'yellow');
%                 %               figure;imshow(B);
%                 
%                               Si= sum(sum(maski));
%                               r=zeros(length(num_cell),1);
%                               for j=1:length(idx)
%                                   roi_j=posroi{idx(j)};
%                 %                 showcellonimg(pos, img_compare)
%                 %                 showimgboundary({roi,roi_j}, img);
%                                   c=centroids(idx(j),:);
%                                   r(j)=median(pdist2(c,roi_j));
%                                   maskj = createCirclesMask([xDim,yDim],c,r(j));
%                                   Sc=sum(sum(maski.*maskj));
%                                   if Sc~=0
%                                       adj_mat(i,idx(j))=Sc/Si;
%                 %                       B = imoverlay(img,maski.*maskj,'yellow');
%                 %                       figure; imshow(B);
%                                   end
%                               end
%                 
%                               mask = createCirclesMask([xDim,yDim],centroids(idx,:),r);
%                               Sir=Si-sum(sum(maski.*mask));
%                               if Sir==0 || Sir <0
%                                   fprintf('Sir = %d , jj=%d, i= %d \n', Sir,jj,i);
%                 
%                               else
%                                   adj_mat(i,i)=Sir/Si;
%                               end
%                 
%                                 pts = intersectPolylines(roi, roi_j);
%                                 %draw two neighborhood polys
%                                 figure; hold on;
%                                 drawPolyline(roi, 'b');
%                                 drawPolyline(roi_j, 'm');
%                                 drawPoint(pts);
%                                 hold off;
%                 %                 axis([0 80 0 80]);
            end
        end
        B = imoverlay(img,over_bw,'yellow');
        figure; imshow(B); 
        adj_mat(1:size(adj_mat)+1:end)=1;
        adj_mat=sparse(adj_mat);
        if det(adj_mat) == 0
           nuancenameFolds{jj};
        end  
       
        compensated_mat2 = aveintensity'*inv(adj_mat);
        compensated_mat2 = compensated_mat2';
        
        compensated_mat3=inv(adj_mat)*aveintensity;
        compensated_mat31=adj_mat\aveintensity;
        
        
%         save([nuancefolder,filesep,nuancenameFolds{jj},filesep,'compensatedmat-1_v2.mat'],'compensated_mat');
        %         save(neighbormat.mat neigh_adj_mat)
%         nuancenameFolds{jj}
        %         close all
        toc
end




