function stimuli=ordStim(list1,list2,chunkN,versionN);
for ind=1:versionN
    list1=ordStims(list1,chunkN);
    list2=ordStims(list2,chunkN);
    stimuli(ind,1,:,:)=list1;
    stimuli(ind,2,:,:)=list2;
    ind
end




    function listout=ordStims(listin,chunkN)
        %% function creates order of stimuli so that no repeating identity is obtained
        %in consequitive pairs
        lengChunk=round(size(listin,1)/chunkN);
        b=1;
        for i=1:chunkN-1
            extrValues(i,1)=b;
            extrValues(i,2)=b+lengChunk-2;
            b=b+lengChunk-1;
        end
        extrValues(i+1,1)=b;
        extrValues(i+1,2)=size(listin,1);
        crit=0;
        counter=1;
        while crit==0;
            listout=[];
            for i=1:size(extrValues,1)
                listA=listin([extrValues(i,1):extrValues(i,2)],:);
                listA=permMat(listA);
                %     mess=[num2str(i) ' is ready out of ' num2str(chunkN)];
                %             display(mess);
                listout([extrValues(i,1):extrValues(i,2)],:)=listA;
            end
            crit=checkMat(listout);
            counter
            counter=counter+1;
        end
    end


    function outMat=permMat(matIn)
        crit=0;
        while crit==0
            z=randperm(length(matIn));
            matIn=matIn(z,:);
            crit=checkMat(matIn);
            outMat=matIn;
        end
        outMat=matIn;
    end

    function crit=checkMat(matIn)
        for i=2:length(matIn)
            
            if rem(matIn(i,1),100)==rem(matIn(i-1,2),100)
                crit=0;
                break
            elseif rem(matIn(i,1),100)==rem(matIn(i-1,1),100)
                crit=0;
                break
            elseif rem(matIn(i,2),100)==rem(matIn(i-1,1),100)
                crit=0;
                break
            elseif rem(matIn(i,2),100)==rem(matIn(i-1,2),100)
                crit=0;
                break
            else crit=1;
            end
            
        end
        
    end
end