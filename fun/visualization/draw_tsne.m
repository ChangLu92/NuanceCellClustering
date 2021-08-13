function fig = draw_tsne(tsne_re,label,clr)

vX = tsne_re(:,1);
vY = tsne_re(:,2);
vColor = label;

vColor_discrete = vColor;
colors = unique(vColor)';
unqValues = unique(vColor);
vZ = vColor;

if isempty(clr)
 clr = distinguishable_colors(numel(unqValues));
end

for ci=1:numel(colors)
    vColor_discrete(vColor==colors(ci)) = ci;
end


% plot
fig = figure;
set(gcf,'Position',[100 100 1000 1000]);
% myplotclr(vX, vY, vZ, vColor_discrete, 'o', clr, [min(vColor_discrete), max(vColor_discrete)], false)

vZ = zeros(length(label), 3);
for i = 1:numel(unqValues)
    vZ(label == unqValues(i),1) = clr(i,1);
    vZ(label == unqValues(i),2) = clr(i,2);
    vZ(label == unqValues(i),3) = clr(i,3);
end
scatter(vX, vY, 15, vZ,'filled');
xlim([-120 120])
ylim([-120 120])
set(gca,'Fontsize',15) 

% if isempty(labelname)
% legend(num2str(unqValues),'Location','eastoutside');
% else
%     lgd = legend(labelname,'Location','eastoutside');
%     lgd.FontSize = 15;
% end

colorbar off;

title('tSNE', 'Fontsize',20);

end

