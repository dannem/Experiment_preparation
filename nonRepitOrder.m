function [vecOut,indOut]=nonRepitOrder(vecIn,indIn,counter)
tic
if nargin<2
   indIn=1:length(vecIn); 
   counter=1;
elseif nargin<3
    counter=1;
end

temp=diff(vecIn);
if find(not(temp))
    firstInd=find(temp==0,1);
    temp1=vecIn(firstInd:end);
    temp2=indIn(firstInd:end);
    ind=randperm(length(temp1));
    temp1=temp1(ind);
    temp2=temp2(ind);
    vecIn(firstInd:end)=temp1;
    indIn(firstInd:end)=temp2;
    counter=counter+1;
    if counter<10
        [vecOut,indOut]=nonRepitOrder(vecIn,indIn,counter);
    else
        vecOut=0;
        indOut=0;
    end
    
else
    vecOut=vecIn;
    indOut=indIn;
end
