function draw_Polar_fig(labels,centers,markername,filename,supername)
[num_c,num_f] = size(centers);
% centers=centers.*1000;
% [centers,PS] = mapminmax(centers,0,100);
% centers = round(centers');
centers = round(centers*10);
unqValues = unique(labels);
row =  ceil(sqrt(num_c));

% row = 10;
% col = 7;

theta = 2*pi/num_f;
color = distinguishable_colors(numel(1:num_f));
% bb=strrep(clu_meth_name,'_','\_'); 


figure(num_c);  % define figure
set(gcf,'Position',[50 50 900 700]);
for ii = 1: num_c
    subplot(row,row,ii);
    c = centers(ii,:);
    for kk = 1: num_f
        the = repmat((kk-1)*theta+theta/2,1,c(kk));
        polarhistogram(the,'BinLimits',[(kk-1)*theta kk*theta],'FaceColor',color(kk,:));
        hold on;
    end
    if ii == 1
        legend(markername,'FontSize',7,'Position', [0.06 0.5 0.02 0.15]); %[left bottom width height]
    end
    ax = gca;
    ax.ThetaTickLabel=[];
    ax.RGrid = 'on';
    rt = ax.RTick;
    ax.RTickLabel= rt/10;
%     ax.ThetaTickLabel = markername;
    ax.FontSize = 6;    
    if isempty(supername)
        n = num2str(unqValues(ii));
    else
        n= supername{ii};
    end   
    ax.Title.String = n ;
    ax.Title.FontSize = 10;
    hold off;
end

% suptitle([bb,' histogram']);
% directory = [newfolder,'\results\',foldername,filesep,clu_meth_name,filesep];
% if ~exist(directory,'dir')
%     mkdir(directory);
% end

print(gcf,'-dpng',[filename,'.jpg']);
end

