function draw_Polar_legend(centers,markername,filename)
[num_c,num_f] = size(centers);
centers = round(centers*10);
theta = 2*pi/num_f;
color = distinguishable_colors(numel(1:num_f));

figure;  % define figure
set(gcf,'Position',[100 100 700 600]);

for kk = 1: num_f
    the = repmat((kk-1)*theta+theta/2,1,centers(kk));
    polarhistogram(the,'BinLimits',[(kk-1)*theta kk*theta],'FaceColor',color(kk,:));
    hold on;
end
rlim([0 1000])
% thetaticks([15:30:345]);
% tt = thetaticks;
% thetaticklabels(markername);
% thetaticklabels('manual');
% rticks([]);

ax = gca;
% ax.ThetaTickLabel=[];
ax.RGrid = 'off';
%rt = ax.RTick;
% ax.RTickLabel= rt/10;
ax.RTickLabel = [];
ax.RTick =[];
ax.ThetaTick = [15:30:345];
ax.ThetaTickLabel = markername;
ax.FontSize = 16;

hold off;
print(gcf,'-dpng',[filename,'.jpg']);
end
