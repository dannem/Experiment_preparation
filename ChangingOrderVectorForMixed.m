% This function takes order file from the identity version of the
% experiment and turns it to the  mixed (gender and identity)
% The order of oddballs has to be generated separately (excel)
% load excel
order=squeeze(outVec(2,1,:,:));
count=1;
for i=1:256*12
    if order(i,2)==2
        if newcodes(count)>0
            order(i,1)=newcodes(count);
            order(i,3)=newcodes(count)-118+200;
            count=count+1;
        else
            count=count+1;
        end
    else
    end
end
outVec(2,1,:,:)=order;
outVec(1,1,:,:)=order;
outVec(2,2,:,:)=order;
outVec(1,2,:,:)=order;

