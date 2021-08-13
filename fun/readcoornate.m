function co_ms=readcoornate(coordinate)
co_ms=zeros(size(coordinate,1)-2,size(coordinate,2));
for i=3:size(coordinate,1)
    %     newStr1 = erase(coordinate{i,1},"-");
    co_ms(i-2,1)=str2double(coordinate{i,1});  %%x-coordinate
    co_ms(i-2,2)=str2double(coordinate{i,2});  %%y-coordinate
    newStr2 = extractBetween(coordinate{i,3},'X','Y');
    newStr3 = extractAfter(coordinate{i,3},'Y');
    co_ms(i-2,3)=str2double(newStr2);  %x-coordinate on MSI
    co_ms(i-2,4)=str2double(newStr3);  %y-coordinate on MSI
end
end

