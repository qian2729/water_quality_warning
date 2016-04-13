function B=svmtransform(A)
[m,~]=size(A);
B=[];
for i=1:m
    temp1=A(i,:);
    temp2=[];
    for j=1:length(temp1)
        temp2=[temp2 ' ' num2str(j) ':' num2str(temp1(j))];
    end    
    B=[B;num2str(i)  temp2];
end

