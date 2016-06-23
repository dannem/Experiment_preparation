function [ord,savVec]=build_EEG_seq(indTrue,indTar,numVersions,numBlocks,numSessions)
% was created to make order files for mixed (famous and unfamiliar faces +
% female targets) experiment.
% Usage: [outVec,savVec]=build_EEG_seq(1:120,121:140,40,16,2);

savVec=[];
% outVec=NaN(numVersions,numSessions,(length(indTrue)*2+length(indTar))*numBlocks,3);
oneEmNum=length(indTrue)/2;
oneTarNum=length(indTar)/2;
blockSize=length(indTrue)*2+length(indTar);
blockVecCode=NaN(blockSize,1);
blockVecKind=ones(blockSize,1);
blockVecTrig=NaN(blockSize,1);
for i=1:numVersions
    i
    for j=1:numSessions
        for k=1:numBlocks
            crit=1;
            k
            while crit
            %creating seperate seqs for first, second repetitions and
            %targets
            tempi1=0;
            while ~tempi1(1)
            temp1=[1:oneEmNum 1:oneEmNum];
            ind1=indTrue(randperm(length(indTrue)));
            temp1=temp1(ind1);
            [tempi1,ind1]=nonRepitOrder(temp1,ind1);
            end
%             ind1=temp1(ind1);
            tempi2=0;
            while ~tempi2(1)
            temp2=[1:oneEmNum 1:oneEmNum];
            ind2=indTrue(randperm(length(indTrue)));
            temp2=temp2(ind2);
            [tempi2,ind2]=nonRepitOrder(temp2,ind2);
            end
%             ind2=indTrue(ind2);
            tarIn=0;
            while ~tarIn(1)
            temp3=[1:oneTarNum 1:oneTarNum];
            ind3=randperm(length(temp3));
            temp3=indTar(ind3);
%             indTar=indTar(ind3);
            [~,tarIn]=nonRepitOrder(temp3,ind3);
            end
            tarIn=temp3(tarIn);
            % placing the seqs in the block seq
            if tempi1(end)==tempi2(1)
            else
                blockVecCode=NaN(blockSize,1);
                blockVecKind=ones(blockSize,1);
                blockVecTrig=NaN(blockSize,1);
                inds=1:blockSize;
                inds=inds(randperm(blockSize));
                blockVecCode(inds(1:length(indTar)))=tarIn;
                blockVecKind(inds(1:length(indTar)))=2;
                blockVecTrig(inds(1:length(indTar)))=tarIn+80;
                inds(1:length(indTar))=[];
                inds=sort(inds);
                blockVecCode(inds)=[ind1 ind2];
                blockVecTrig(inds)=[ind1 ind2];
                for l=1:length(blockVecTrig)
                    if blockVecTrig(l)<oneEmNum+1
                    elseif blockVecTrig(l)<oneEmNum*2+1
                        blockVecTrig(l)=blockVecTrig(l)+100-oneEmNum;
                    end
                end
%                 outVec(i,j,[1:blockSize]+(k-1)*blockSize,3)=blockVecTrig;
%                 outVec(i,j,[1:blockSize]+(k-1)*blockSize,1)=blockVecCode;
%                 outVec(i,j,[1:blockSize]+(k-1)*blockSize,2)=blockVecKind;
                  ord.mat(i,3,j,k,:)=blockVecTrig;
                  ord.mat(i,1,j,k,:)=blockVecCode;
                  ord.mat(i,2,j,k,:)=blockVecKind;
                savVec=[savVec; blockVecCode blockVecKind blockVecTrig];
                crit=0;
            end
            end
        end
    end
end
       
        