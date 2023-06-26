candidate_set = load("NSGAIII_WFG8_M5.mat").candidate;
% Two-Phase procedure
% The large scandidate set is divided into 100 subsets based on the cosine
% similarity (random seed is set as 1).
n=100;
subsets = division(candidate_set, n, "balanced_mini_batch_kmeans", 1);
st = tic;
compare_cnt = 0;
merged_set = [];
% Dominated solutions are removed from each subset independently
for i=1:n
    [frontNum, ~, cp] = NDSort(subsets{i},1);
    merged_set = [merged_set; subsets{i}(frontNum==1,:)];
    compare_cnt = compare_cnt + cp; 
end
% Dominated solutions are removed from the merged set
[frontNum, ~, cp] = NDSort(merged_set,1);
compare_cnt = compare_cnt + cp; 
result = merged_set(frontNum==1,:);
fprintf("\n----------Two-Phase Procedure----------\n")
fprintf("Computation time:%f s\n",toc(st));
fprintf("Number of comparisons:%d\n",compare_cnt);
fprintf("Number remaining solutions after the first phase:%d\n",size(merged_set,1));
fprintf("Number remaining solutions after the second phase:%d\n",size(result,1));

% One-Phase procedure
st = tic;
[frontNum, ~, cp] = NDSort(candidate_set,1);
sprintf("\n----------One-Phase Procedure----------\n")
sprintf("Computation time:%f s",toc(st))
sprintf("Number of comparisons:%d",cp)
result = candidate_set(frontNum==1,:);
sprintf("Number remaining solutions:%d",size(result,1))
