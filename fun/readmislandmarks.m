function [TP_mat,TP_mat2,Points_mat]=readmislandmarks(misfilename)
mis = fopen(misfilename,'r');
formatSpec = '%c';
mis_file = fscanf(mis,formatSpec);
TPfile = extractBetween(mis_file,'</CoRegType>','<CoRegVersion>');
TP = extractBetween(TPfile,'<TeachPoint>','</TeachPoint>');

TPfile2 = extractBetween(mis_file,'</MDFParameters>','<ReferencePoint>');
TP2 = extractBetween(TPfile2,'<TeachPoint>','</TeachPoint>');

pointsfile = extractBetween(mis_file,'</CoRegistration>','</Area>');
Points = extractBetween(pointsfile,'<Point>','</Point>');
% Points = extractBetween(mis_file,'<Point>','</Point>');
TP_mat=zeros(size(TP,1),4);
TP_mat2=zeros(size(TP2,1),4);
Points_mat=zeros(size(Points,1),2);
for ii=1:size(TP,1)
    Ct = strsplit(TP{ii},{',',';'});
    TP_mat(ii,:)=str2double(Ct);
end

for ii=1:size(TP2,1)
    Ct = strsplit(TP2{ii},{',',';'});
    TP_mat2(ii,:)=str2double(Ct);
end

for ii=1:size(Points,1)
    Cp = strsplit(Points{ii},',');
    Points_mat(ii,:)=str2double(Cp);
end
end