function [savVec,outVec]=Recon_EEG_Order(numberOfVersions,numberOfBlocks,numberOfSessions,numOfCatch)
%% parameters
% numberOfVersions=40;
% numberOfBlocks=15;
% numberOfSessions=2;

%% preparing vector for good trials in one block
a=[1:118]';
good=[a;a];

%% preparing vector for catch trials in one session
numOfStim=length(good)*numberOfBlocks+numOfCatch;
numOfStimPerBlock=length(good)+numOfCatch/numberOfBlocks;
%% creating order file
savVec=[];
outVec=zeros(numberOfVersions,numberOfSessions,numOfStim,3);
for i=1:numberOfVersions;
    i
    for j=1:numberOfSessions
        %         display(['j is ' num2str(j)]);
        catchTrialsAll=repmat(a(randperm(length(a))),10,1);
        catchTrials=catchTrialsAll(1:numOfCatch,1);
        for k=1:numberOfBlocks
            catchCounter=1;
            stat=0;
            while stat==0
                good2=ones(size(good));
                stat2=0;
                while stat2==0 % making sure that identities don't repeat
                    good(randperm(length(good)))=good;
                    good1=good;
                    stat2=checkRepet(good1,1);
                end
                catVec=catchTrials((k-1)*(numOfCatch/numberOfBlocks)+1:k*(numOfCatch/numberOfBlocks));
                for u=1:numOfCatch/numberOfBlocks
                    if catVec(u)<60
                        numNow=catVec(u)+59;
                    else
                        numNow=catVec(u)-59;
                    end
                    z=find(good1==numNow);
                    d=diff(z);
                    if length(z)==2
                        z(randperm(length(z)))=z;
                        good1=[good1(1:z(1));catVec(u);good1(z(1)+1:end)];
                        good2=[good2(1:z(1));2;good2(z(1)+1:end)];
                    elseif d(1)==1
                        good1=[good1(1:z(2));catVec(u);good1(z(2)+1:end)];
                        good2=[good2(1:z(2));2;good2(z(2)+1:end)];
                    elseif d(2)==1
                        good1=[good1(1:z(1));catVec(u);good1(z(1)+1:end)];
                        good2=[good2(1:z(1));2;good2(z(1)+1:end)];
                    else
                        z(randperm(length(z)))=z;
                        good1=[good1(1:z(1));catVec(u);good1(z(1)+1:end)];
                        good2=[good2(1:z(1));2;good2(z(1)+1:end)];
                    end
                    
                    
                end
                stat=checkRepet(good1,2);
            end
            good3=zeros(size(good1));
            for q=1:size(good1)
                if good1(q)<60
                    good3(q)=good1(q);
                else
                    good3(q)=good1(q)+41;
                end
            end
            outVec(i,j,(k-1)*numOfStimPerBlock+1:k*numOfStimPerBlock,1)=good1;
            outVec(i,j,(k-1)*numOfStimPerBlock+1:k*numOfStimPerBlock,2)=good2;
            outVec(i,j,(k-1)*numOfStimPerBlock+1:k*numOfStimPerBlock,3)=good3;
            tempvec=[good1 good2 good3];
            savVec=[savVec;tempvec];
            save('stim.mat','outVec');
            
        end
    end
    
end

    function stat=checkRepet(vect,doCorrection)
        if doCorrection==1
            for b=1:length(vect)
                if vect(b)>59
                    vect(b)=vect(b)-59;
                else
                    %                 vect(b)=vect(b)+60;
                end
            end
            if any(~diff(vect))
                stat=0;
            else
                stat=1;
            end
        elseif doCorrection==2
            for b=1:length(vect)
                if vect(b)>59
                    vect(b)=vect(b)-59;
                else
                    %                 vect(b)=vect(b)+60;
                end
            end
            diffK=diff(vect);
            for b=1:length(diffK)-2;
                if sum(diffK(b:b+1))==0
                    stat=0;
                    break
                else
                    stat=1;
                end
            end
        else
           if any(~diff(vect))
                stat=0;
            else
                stat=1;
            end 
        end
        
        
        
        
    end

end
