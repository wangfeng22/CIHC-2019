function [ m ] = calc_syndrome( code, x )
%CALC_SYNDROME calculates syndrome of code from word x.
%
% Tomas Filler (tomas.filler@binghamton.edu)
% http://dde.binghamton.edu/filler

m = zeros(sum(code.shift),1);
m_id = 1;
tmp = uint32(0);
for i = 1:code.n
    hi = uint32(code.h(i));
    if x(i)==1
        tmp = bitxor(hi, tmp);
    end
    for j = 1:code.shift(i)
        m(m_id) = mod(tmp,2);
        tmp = bitshift(tmp,-1); % bit shift
        m_id = m_id + 1;
    end
end
end
