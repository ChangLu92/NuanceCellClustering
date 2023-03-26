function c=getmedian(X, labels)
   UL=unique(labels);
   c=zeros(length(UL),size(X,2));
   for i=1:length(UL)
       X_i=X(labels==UL(i),:);
       c(i,:)=median(X_i);
   end
end

