problems = ["NSGAIII_WFG1_M5"];
% problems = ["NSGAIII_WFG1_M5","NSGAIII_WFG1_M10", "NSGAIII_WFG2_M5", "NSGAIII_WFG2_M10", "NSGAIII_WFG3_M5",...
%          "NSGAIII_WFG3_M10","NSGAIII_WFG4_M5", "NSGAIII_WFG4_M10", "NSGAIII_WFG5_M5", "NSGAIII_WFG5_M10"...
%          "NSGAIII_WFG6_M5", "NSGAIII_WFG6_M10","NSGAIII_WFG7_M5","NSGAIII_WFG7_M10","NSGAIII_WFG8_M5",...
%          "NSGAIII_WFG8_M10","NSGAIII_WFG9_M5","NSGAIII_WFG9_M10","DDMOP1","DDMOP2","DDMOP3","DDMOP4",...
%          "DDMOP5"];
for problem = problems
     runNDSort(false,"","",1:10,problem);
     runNDSort(true,100,"balanced_mini_batch_kmeans",1:10,problem);
end
% for problem = problems
%      runNDSort(true,-1,"random",1:10,problem);
%      runNDSort(true,-1,"angle",1:10,problem);
%      runNDSort(true,-1,"linear",1:10,problem);
%      runNDSort(true,-1,"balanced_mini_batch_kmeans",1:10,problem);
% end
% for problem = problems
%    runNDSort(true,10,"balanced_mini_batch_kmeans",1:10,problem);
%    runNDSort(true,100,"balanced_mini_batch_kmeans",1:10,problem);
%    runNDSort(true,1000,"balanced_mini_batch_kmeans",1:10,problem);
%    runNDSort(true,10000,"balanced_mini_batch_kmeans",1:10,problem);
% end

function runNDSort(isTwoPhase, n, method, runs, names)
    % isTwoPhase: two-phase or one-phase
    % n:          number of subsets
    % method:     partition method
    % run:        runs

    % test different candidate sets    
    for p=1:length(names)
        name = names(p);
        name
        % Original nondominated sorting (One-phase)
        allRes = {}; % number of nondominated solutions. 
        allTime = {}; % computation time
        allCompareCnt = {}; % number of comparsions
        % Two-phase nondominated sorting
        allSet1={}; % number of solutions in each subset after partition
        allSet2={}; % number of solutions in each subset after removing dominated solutions
        parfor k=1:length(runs) % length(runs) cpu cores are used in matlab
            r = runs(k);
            path = sprintf("./Data/Candidate/%s.mat", name);
            candidate = parLoad(path).candidate;
            if isTwoPhase
                % when comparing different partition method, the value of n is determined
                % by M.
                M = size(candidate,2);
                if n==-1
                    if M==2
                        divisionNum=100;
                    elseif M==3
                        divisionNum=120;
                    elseif M==5
                        divisionNum=126;
                    elseif M==9
                        divisionNum=174;
                    elseif M==10
                        divisionNum=275;
                    end
                else
                    divisionNum = n;
                end

                recorder = TwoPhaseNDSort(candidate, divisionNum, method, r, true);
                allSet1{k} = recorder.set1;
                allSet2{k} = recorder.set2;
                allRes{k} = recorder.res;
                allTime{k} = recorder.time;
                allCompareCnt{k} = recorder.allCompareCnt;
            else
                rng(r);
                st = tic;
                [frontNum, ~,cp] = NDSort(candidate,1);              
                res = candidate(frontNum==1,:);
                time = toc(st);
                allRes{k}=size(res,1);
                allTime{k}=time;
                allCompareCnt{k}=cp;
            end
        end
        % save the result
        if isTwoPhase
            folder = sprintf('./Data/Result/%s_n%d',method, n);
            if (~exist(folder,'dir'))
                mkdir(folder);
            end
            save(sprintf("%s/%s_r%d_%d.mat",folder,name, runs(1), runs(end)), "allSet1", "allSet2",...
                "allRes","allTime","runs","names","allCompareCnt");
        else
            save(sprintf("./Data/Result/Origin/%s_r%d_%d.mat",name,runs(1), runs(end)),...
                "allRes","allTime","runs","names","allCompareCnt");
        end
    end

end

function res = parLoad(path)
    res = load(path);
end
