# Two-Phase-Procedure-For-Removing-Dominated-Solutions

#### Explanation for Important Files

Example.m: As an example, we compared the two-phase procedure with the one-phase procedure using a candidate set with one million solutions.

Exp.m: The main codes for the experiments  are contained in this file

division.m: Different partition methods are contained in this file.



#### Candidate Set Generation

Candidate sets are generated in two ways:

**Type I (18 candidate sets):** All examined solutions of a test problem in a single run of a single EMO algorithm (for the use of an unbounded external archive)

**Type II (5 candidate sets):** All examined solutions of a test problem in multiple runs of multiple EMO algorithms (for Pareto front approximation for a test problem)

The candidate sets can be download by https://www.jianguoyun.com/p/DUTUcGUQmoWmChiMm44FIAA



#### Two-Phase Procedure for Dominated Solution Removal

- For the dominated solution removal, we use an efficient method T-ENS which is used in PlatEMO.

  Source code: https://github.com/BIMK/PlatEMO/blob/master/PlatEMO/Algorithms/Utility%20functions/NDSort.m

- For the candidate set partition, we using a clustering algorithm to divide candidate solutions into several subsets based on the cosine similarity (see division.m)







