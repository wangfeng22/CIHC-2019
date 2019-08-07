clc; clear;

% either use optimized matrix H_hat
load('dv_best_submatrices.mat');
H_hat = double(submatrices{3,7}); % constraint length 7 and width 3.
% Not all combinations are known.

H = create_pcm_from_submatrix(H_hat, 50);
draw_pcm(H);

% code = structure with all necesary components
code = create_code_from_submatrix(H_hat, 50);
w = ones(code.n,1);
x = double(rand(code.n,1)<0.5);
m = double(rand(sum(code.shift),1)<0.5);

[y min_cost] = dual_viterbi(code, x, w, m);

if (all(m'==calc_syndrome(code,y)'))
    fprintf('Message extracted without any error.\n');
else
    fprintf('ERROR\n');
end

min_cost
