function [sequence,pairs] = best_sequence(sequence,pairs,recFactor)
if isempty(pairs)% when pairs end
elseif length(pairs)<recFactor;
elseif isempty(sequence)% initializing sequence
    pairs=pairs(randperm(length(pairs)),:);
    sequence(1)=pairs(1,1);
    sequence(2)=pairs(1,2);
    pairs(1,:)=[];
    [sequence,pairs] = best_sequence(sequence,pairs,recFactor);
else
    st1=sequence(1);
    st2=sequence(end);
    [ind(1),freq(1)]=best_pair(pairs,st1,1);
    [ind(2),freq(2)]=best_pair(pairs,st1,2);
    [ind(3),freq(3)]=best_pair(pairs,st2,1);
    [ind(4),freq(4)]=best_pair(pairs,st2,2);
    if isnan(freq)
    else
        indMax=find(freq==max(freq));% finding index of max freq
        indMax=indMax(1);% making sure it's only one
        mfreq=ind(indMax);% finding the true index in 'pair' mat
        if indMax==1
            sequence=[pairs(mfreq,2) sequence];
        elseif indMax==2
            sequence=[pairs(mfreq,1) sequence];
        elseif indMax==3
            sequence=[sequence pairs(mfreq,2)];
        else
            sequence=[sequence pairs(mfreq,1)];
        end
        pairs(mfreq,:)=[];
        [sequence,pairs] = best_sequence(sequence,pairs,recFactor);
    end
end




function [ind,freq]=best_pair(pairs,value,column)
npairs=pairs((pairs(:,column)==value),:); % find pairs with the needed value
if isempty(npairs)% if such pairs are not found
    ind=NaN;
    freq=NaN;
else
    npairs=npairs(:); %vectorize the matrix of pairs with the needed value
    npairs=npairs(npairs~=value); %finding other values
    newpairs=pairs(:);
    onemat=newpairs(find(ismember(newpairs,npairs)));
    npairs=tabulate(onemat);% looking for frequency of the values
    freq=max(npairs(:,2));% finding maximum frequency
    pos=find(npairs(:,2)==freq);% finding where max. freq belong
    pos=pos(randperm(length(pos)));
    pos=pos(1);
    valu=npairs(pos,1);% finding value corresponding to max freq
    if column==1;
        ind=find(ismember(pairs,[value valu],'rows'));% finding index in the original mat
    else
        ind=find(ismember(pairs,[valu value],'rows'));% finding index in the original mat
    end
    ind=ind(1);
end



