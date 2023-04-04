function sets=balanced_mini_batch_kmeans(candidate, n, b)
    N = size(candidate,1);
    sets = mini_batch_kmeans(candidate,n, b);
    %% reassign
    siz = zeros(1,n);
    for i=1:n
        siz(i)=size(sets{i},1);
    end
    [~,minI] = sort(siz);
    cnt = 1;
    desireSiz = ceil(N/n);
    for i=1:n
        if siz(i)>2*desireSiz
            num = floor(siz(i)/desireSiz);
            newsets = redivision(sets{i},num);
            sets{i}=newsets{1};
            for j=2:num
                sets{minI(cnt)}=[sets{minI(cnt)};newsets{j}];
                cnt = cnt +1;
            end
        end
    end
end

function r = sample(N, x)
    r = randperm(N);
    r = r(1:x);
end
function res = normalize(val, PF) % nomrmalize the obecjtive values by PF
    N = size(val,1);
    fmin   = min(PF, [], 1);
    fmax   = max(PF,[],1);
    res = (val-repmat(fmin,N,1))./repmat(fmax-fmin,N,1);
end

function sets = redivision(candidate, n)
    [N,M] = size(candidate);
    copy_candidate = candidate;
    s = ceil(N/n);
    index = 1:N;
    sets = {};
    center=ones(1,M);
    for i=1:n
        selectNum = min(s, length(index));
        [~, I] = max(pdist2(center, candidate, 'cosine'), [], 2);
        [~, I] = mink(pdist2(candidate(I,:), candidate, 'cosine'), selectNum);
        sets{i} = index(I);
        index(I)=[];
        candidate(I,:)=[];
    end
    for i=1:n
        sets{i}=copy_candidate(sets{i},:);
    end
end
