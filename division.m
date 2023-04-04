function sets = division(candidate, n, method, seed)
    sets = {};
    [N, M] = size(candidate);
    rng(seed);
    if method == "angle" % Reference vector-based partition
        vecs = UniformPoint(n, M);
        norm_candidate = normalize(candidate,candidate);
        angles = pdist2(norm_candidate, vecs, 'cosine');
        [~, index] = min(angles, [], 2);
        for i=1:n
            sets{i} = candidate(index==i,:);
        end
    elseif method == "linear" % first objective-based partition
        [B,I] = sort(candidate(:,1));
        candidate = candidate(I,:);
        siz = ceil(N/n);
        for i=1:n
            sets{i}=candidate((i-1)*siz+1:min(i*siz,end), :);
        end
    elseif method == "random" % random partition
        candidate = candidate(randperm(N),:);
        siz = ceil(N/n);
        for i=1:n
            sets{i}=candidate((i-1)*siz+1:min(i*siz,end), :);
        end
    elseif method == "balanced_mini_batch_kmeans" % clustering-based partition
        sets = balanced_mini_batch_kmeans(candidate,n,1000);
    else
        error("No such division method!")
    end
end

% nomrmalize the obecjtive values by PF
function res = normalize(val, PF) 
    N = size(val,1);
    fmin   = min(PF, [], 1);
    fmax   = max(PF,[],1);
    res = (val-repmat(fmin,N,1))./repmat(fmax-fmin,N,1);
end