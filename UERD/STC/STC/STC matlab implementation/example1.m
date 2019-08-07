clc; clear;

H_hat = [7 5 1];

H = create_pcm_from_submatrix(H_hat, 3)
draw_pcm(H);

% code = structure with all necesary components
code = create_code_from_submatrix(H_hat, 3);
w = ones(code.n,1);
x = double(rand(code.n,1)<0.5);
m = double(rand(sum(code.shift),1)<0.5);
[y min_cost] = dual_viterbi(code, x, w, m);
x = x'; x
y = y'; y
m = [m' ; calc_syndrome(code,y)']; m
min_cost
