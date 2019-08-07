function [ y min_cost paths ] = dual_viterbi( code, x, w, m )
%DUAL_VITERBI pure Matlab implementation of the Viterbi algorithm over 
% syndrome trellis. For given code, binary cover vector x, weight 
% vector w, finds the closest binary 'stego' vector y that produces given 
% syndrome m. Use dual_viterbi() for faster C++ implementation.
%
% Example:
%   code = create_code_from_submatrix([7 5 1],3);
%   w = ones(code.n,1);
%   x = double(rand(code.n,1)<0.5);
%   m = double(rand(sum(code.shift),1)<0.5);
%   [y min_cost] = dual_viterbi(code, x, w, m);
%   x = x'; x
%   y = y'; y
%   m = [m' ; calc_syndrome(code,y)']; m
%   min_cost
%
% Tomas Filler (tomas.filler@binghamton.edu)
% http://dde.binghamton.edu/filler

%% check input parameters
if length(m)~=sum(code.shift)
    error('dualViterbi:wrongInputArg', 'Syndrome must be of the same length as the number of shifts in code.');
end
if length(x)~=length(w)
    error('dualViterbi:wrongInputArg', 'Cover vector must be of the same size as weight vector.');
end
if length(x)~=code.n
    error('dualViterbi:wrongInputArg', 'Cover vector must be of the same length as the code.');
end
%% initialize datastructures
C = zeros(2^code.l,code.n);
costs = inf*ones(2^code.l, 1);
costs(1) = 0;
paths = zeros(2^code.l, code.n);
m_id = 1; % message bit id
y = zeros(size(x));
%% run forward algorithm
for i = 1:code.n  % for every bit in cover
    costs_old = costs;
    hi = uint32(code.h(i)); % column represented as uint32
    ji = uint32(1);
    for j = 1:2^code.l
        c1 = costs_old(ji) + x(i)*w(i);
        c2 = costs_old(bitxor(ji-1,hi)+1) + (1-x(i))*w(i);
        if c1<c2
            costs(j) = c1;
            paths(j,i) = ji; % store index of the previous path
        else
            costs(j) = c2;
            paths(j,i) = bitxor(ji-1,hi)+1; % store index of the previous path
        end
        ji = ji + 1;
    end
    % shift the trellis by shift(i)
    for j = 1:code.shift(i)
        if isinf(min(costs( m(m_id)+1:2:end )))
            error('dualViterbi:noSolution', 'No possible solution exists.');
        end
        if m(m_id)==0
            costs = [costs(1:2:end) ; inf*ones(2^(code.l-1),1)];
        else
            costs = [costs(2:2:end) ; inf*ones(2^(code.l-1),1)];
        end
        m_id = m_id + 1;
    end
    C(:,i) = costs;
end
%% backward run
[min_cost ind] = min(costs);
m_id = m_id - 1;
for i = code.n:-1:1
    for j = 1:code.shift(i)
        ind = 2*ind + m(m_id) - 1; % invert the shift in syndrome trellis
        m_id = m_id - 1;
    end
     y(i) = paths(ind,i)~=ind;
     ind = paths(ind,i);
end
end
