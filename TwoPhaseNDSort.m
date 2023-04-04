function R = TwoPhaseNDSort(arc, n, method, seed, twoPhase)
    % arc:    a large solution set which contains some dominated solutions
    % n:      number of subsets 
    % method: partition method
    % seed:   random seed for partition method
    % twoPhase: if false, only return the merged set after the first phase. 
    %           if true, return the final result  
    rng(seed);
    R = {};
    R.time = zeros(1,3);
    R.res = zeros(1,2);
    R.set1 = zeros(1,n);
    R.set2 = zeros(1,n);
    st = tic;
    % Partition
    sets = division(arc, n, method, seed);
    R.time(1) = toc(st); % Time for division
    res = [];
    cnt1 = 0;
    cnt2 = 0; 
    for i=1:n
        R.set1(i) = size(sets{i},1);
        [frontNum, ~, cp] = NDSort(sets{i},1);
        cnt1 = cnt1+cp;
        R.set2(i) = sum(frontNum==1);
        res = [res;sets{i}(frontNum==1,:)];
    end
    R.time(2) = toc(st)-R.time(1);% Time for NDSort in Phase 1
    R.res(1)=size(res,1);
    if twoPhase
        [frontNum, ~, cp] = NDSort(res,1);
        cnt2 = cp;
        res = res(frontNum==1,:);
        R.res(2)=size(res,1);
        R.time(3)=toc(st)-R.time(2)-R.time(1);% Time for NDSort in Phase 2
        R.allCompareCnt=[cnt1,cnt2];
    end
end