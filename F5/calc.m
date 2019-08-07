function [n k] = calc(nonzero, ciphernum)
n = floor(nonzero/ciphernum);
k = floor(log2(n+1));
n = power(2,k) - 1;
