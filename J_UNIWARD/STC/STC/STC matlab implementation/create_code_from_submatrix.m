function [ code alpha ] = create_code_from_submatrix( H_hat, num_of_sub_blocks )
%CREATE_CODE_FROM_SUBMATRIX creates code from binary submatrix H_hat by
% replicating it by num_of_sub_blocks times. H_hat can be either binary
% matrix or row of integers, where integer represents the binary vector.
%
% Example (both gives the same code):
%   create_code_from_submatrix([1 1 1;1 0 0;1 1 0],3)
%   create_code_from_submatrix([7 5 1],3)
%
% Output:
% ans = 
%         n: 9
%         l: 3
%         h: [7 5 1 7 5 1 7 5 1]
%     shift: [0 0 1 0 0 1 0 0 1]
%
% Represents code with the following parity check matrix
%
%    1 1 1 0 0 0 0 0 0
%    1 0 0 1 1 1 0 0 0
%    1 1 0 1 0 0 1 1 1
%
% Tomas Filler (tomas.filler@binghamton.edu)
% http://dde.binghamton.edu/filler

%% check input parameters
if ~isa(H_hat, 'double')
    error('Matrix H_hat must be of type double.');
end
if size(H_hat,1)>1
    % binary matrix should be on input
    if (sum(H_hat(:)==0) + sum(H_hat(:)==1))~=numel(H_hat)
        error('Matrix H_hat must be binary.');
    end
else
    % matrix should be ful of non-negative number representing columns in
    % binary notation, maximum is 32 bits
    if any(H_hat>2^32)
        error('Maximal height of H_hat is 32.');
    end
end
if size(H_hat,1)>32
    error('Maximal height of H_hat is 32.');
end

%% calculate the code
m = size(H_hat,2);
% H_hat may be of different kind, either binary or single row, where binary
% vectors are written in binary notation as single integer.
if size(H_hat,1)>1
    H_hat_uint32 = zeros(1, m, 'uint32');
    for i = 1:m
        H_hat_uint32(i) = uint32(binvec2dec( H_hat(:,i)' ));
    end
else
    H_hat_uint32 = H_hat;
    H_hat = zeros(32,m);
    for i = 1:m
        H_hat(:,i) = dec2binvec(H_hat_uint32(i), 32)';
    end
end

% length of the code
code.n = m*num_of_sub_blocks;

% constraint length = index of the last nonzero row
code.l = find( sum(H_hat,2)>0, 1, 'last');

% sparse matrix represented by vector of uint32s
code.h = repmat(double(H_hat_uint32), 1, num_of_sub_blocks);

% vector representing the shifts in parity check matrix of the code
code.shift = repmat([zeros(1,m-1) 1], 1, num_of_sub_blocks);

alpha = calc_relative_payload(code);
end

