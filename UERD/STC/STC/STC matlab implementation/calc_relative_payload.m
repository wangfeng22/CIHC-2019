function [ alpha ] = calc_relative_payload( code )
%CALC_CODE_RATE calculates relative payload (1-rate) of a given code.
%
% Tomas Filler (tomas.filler@binghamton.edu)
% http://dde.binghamton.edu/filler

alpha = sum(code.shift)/code.n;
end
