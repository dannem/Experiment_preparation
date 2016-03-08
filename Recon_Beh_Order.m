clc
clear all
blockNum=8;
stimNum=59  ;
sameNumRep=6;
varNum=4;
for j=1:varNum;
    j
    counter=0;
    crit=1;
    while crit
        [sequence,pairs] = best_sequence([],nchoosek(1:stimNum,2),1500);
        [sequence,pairs] = best_sequence(sequence,pairs,1100);
        [sequence,pairs] = best_sequence(sequence,pairs,700);
        [sequence,pairs] = best_sequence(sequence,pairs,300);
        [sequence,pairs] = best_sequence(sequence,pairs,0);
        if length(pairs)==0
            crit=0;
            tempBl=round(length(sequence)/blockNum);
            for i=1:blockNum
                temp=sequence((i-1)*tempBl+1:i*tempBl);
                temp=temp(:);
                res=tabulate([temp; stimNum]);
                res(stimNum,2)=res(stimNum,2)-1;
                out(:,i)=res(:,2);
            end
            if max(max(out))>5
                %                 display('Ouliers')
                %                 max(max(out))
                %                 min(min(out))
                crit=1;
            end
        end
        %% inserting last trial to offset the interuption of the sequence caused by breaks
        if ~crit
            lengthSeq=length(sequence);
            lengthBlock=floor(lengthSeq/blockNum);
            seqVec=NaN(size(sequence,1),size(sequence,2)+blockNum-1);
            
            for i=1:blockNum-1;
                range=1+(i-1)*(lengthBlock+1):1+(i-1)*(lengthBlock+1)+lengthBlock-1;
                seqVec(range)=sequence(1+(i-1)*lengthBlock:i*lengthBlock);
                seqVec(range(end)+1)=sequence(lengthBlock*i+1);%adding first number of the next block to the last place of the current block
            end
            seqVec((lengthBlock+1)*i+1:end)=sequence(i*lengthBlock+1:end); % adding last block (no repetition)
            lengthBlock=floor(length(seqVec)/blockNum);
            for i=1:blockNum
                temp=seqVec((i-1)*lengthBlock+1:i*lengthBlock);
                temp=temp(:);
                res=tabulate([temp; stimNum]);
                res(stimNum,2)=res(stimNum,2)-1;
                out(:,i)=res(:,2);
            end
            if max(max(out))>5 | min(min(out))<2
                display('Ouliers')
                max(max(out))
                min(min(out))
                crit=1;
            end
        end
    end
    order(j,:)=seqVec;
end
% load('/Users/dannem/Desktop/matlab.mat')
ord.names={'variant','variable: 1-im,2-resp,3-id','session','block','trial'};
lengthBlock=216;
for i=1:varNum
    display(['Variant number: ' num2str(i)])
    temp=order(i,:);
    crit1=1;
    while crit1
        same=repmat([1:stimNum],1,sameNumRep);
        sameAll=same(randperm(length(same)));
        for j=1:blockNum
            block=temp(1+(j-1)*lengthBlock:j*lengthBlock);
            crit=1;
            finalSame=22;
            if j==1
                finalSame=23;
            end
            while crit
                same=sameAll;
                bl=block;
                trigger=ones(size(bl));
                trigger(1)=3;
                for k=1:finalSame
                    same=same(randperm(length(same)));
                    try
                        ind=find(bl==same(1));
                    catch
                        crit=1;
                        same=same(randperm(length(same)));
                        break
                    end
                    ind=ind(randperm(length(ind)));
                    bl=[bl(1:ind) same(1) bl(ind+1:end)];
                    trigger=[trigger(1:ind) 2 trigger(ind+1:end)];
                    same(1)=[];
                    crit=0;
                end
                if j==9
                    bl=[bl temp(end)];
                    trigger=[trigger 1];
                end
                res=tabulate([bl 59]);
                res(59,2)=res(59,2)-1;
                
                if max(res(:,2))>6 | min(res(:,2))<2
                    display('Ouliers')
                    %                 max(max(res(:,2)))
                    %                 min(min(res(:,2)))
                    crit=1;

                end
                a=diff(bl);
                a=find(a==0);
                a=diff(a);
                if ismember(a,1);
                    crit=1;
                    
                end
                crit1=0;
                if crit & j==9
                    crit=0;
                    crit1=1;
                end
            end
            sameAll=same;
            temp1=repmat([59 0],1,round(length(bl)/2)+2);
            temp1=temp1(1,1:length(bl));
            ord.mat(i,1,1,j,:)=bl+temp1;
            ord.mat(i,2,1,j,:)=trigger;
            ord.mat(i,3,1,j,:)=bl;
            temp1=repmat([0 59],1,round(length(bl)/2)+2);
            temp1=temp1(1,1:length(bl));
            ord.mat(i,1,2,j,:)=bl+temp1;
            ord.mat(i,2,2,j,:)=trigger;
            ord.mat(i,3,2,j,:)=bl;
            
        end
        
        
    end
end
%     %% inserting same trials
%     temp=repmat([1:stimNum],1,sameNumRep);
%
%     %     corrAns=zeros(1,length(seqVec));
%
%     for i=1:length(temp)
%         vec=find(seqVec==temp(i));
%         vec=vec(randperm(length(vec)));
%         ind=vec(1);
%         seqVec=[seqVec(1:ind) temp(i) seqVec(ind+1:end)];
%         corrAns=[corrAns(1:ind) 1 corrAns(ind+1:end)];
%     end
%
%     %% inserting trials at the end of blocks
%     lengthSeq=length(seqVec)+blockNum-1;
%     lengthBlock=lengthSeq/blockNum;
%     for i=1:blockNum-1;
%         seqVec=[seqVec(1:lengthSeq/blockNum*i-1) NaN  seqVec(lengthSeq/blockNum*i:end)];
%         seqVec(lengthSeq/blockNum*i)=seqVec(lengthSeq/blockNum*i+1);
%         corrAns=[corrAns(1:lengthSeq/blockNum*i) 3  corrAns(lengthSeq/blockNum*i+1:end)];
%     end
%
%     temp=repmat([60 0],1,round(length(seqVec)/2)+2);
%     temp=temp(1,1:length(seqVec));
%     orderFile(j,1,1,:)=seqVec+temp;
%     orderFile(j,1,2,:)=corrAns;
%     temp=repmat([0 60],1,round(length(seqVec)/2)+2);
%     temp=temp(1,1:length(seqVec));
%     orderFile(j,2,1,:)=fliplr(seqVec)+temp;
%     orderFile(j,2,2,:)=corrAns;
% end
% ord=ord(1,:,:,:,:);
% temp1=repmat([0:60],1,round(237/2)+2);
% temp1=temp1(1,1:237);
%
% for i=1:9
%     a=fliplr(squeeze(ord(1,2,1,i,:)));
%     ord(1,2,2,i,:)=a;
% end
% ord=squeeze(ord(1,:,:,:,:));
% temp1=repmat([0 60],1,round(237/2)+2);
% temp1=temp1(1,1:237);
% temp2=repmat([60 0],1,round(237/2)+2);
% temp2=temp1(1,1:237);
% for i=1:9
%     a1=squeeze(ord(1,i,:))'+temp1;
%     a2=squeeze(ord(2,i,:));
%     b1=fliplr(squeeze(ord(1,i,:))'+temp2);
%     b2=fliplr(squeeze(ord(2,i,:))');
%     b2(end)=[];
%     b2=[3 b2];
%     order(1,1,i,:)=a1;
%     order(2,1,i,:)=a2;
%     order(1,2,i,:)=b1;
%     order(2,2,i,:)=b2;
% end
% a=squeeze(order(1,2,:,:));
% b=squeeze(order(1,1,:,:));
% c=squeeze(order(2,2,:,:));
% d=squeeze(order(2,1,:,:));