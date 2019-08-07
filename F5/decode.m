function cipherbit = decode(dct_sh, cnt, len)
    nonzero = sum(sum(dct_sh~=0));
    ciphernum = cnt*len;

    [n k] = calc(nonzero, ciphernum);
    
    ciphernum_align = ceil(ciphernum/k)*k;
    cipherbit_align = char(ones(1,ciphernum_align)*'0');
    
    index = 1;
    for i=1:ceil(ciphernum/k)
        [fa index] = decode_ex(dct_sh, index, n);
        fa_bin = dec2bin(fa);
        cipherbit_align(i*k-length(fa_bin)+1:i*k) = dec2bin(fa);
    end
    cipherbit = reshape(cipherbit_align(1:len*cnt), len, cnt)';  
end

function [fa index] = decode_ex(dct_sh, index, n)
    dct_n = get_dct_n(dct_sh, index, n);
    index = dct_n(end) + 1;
    fa = mod(dct_sh(dct_n(1)),2);
    for i=2:n
        fa = bitxor(fa, mod(dct_sh(dct_n(i)),2)*i);
    end
end

function dct_n = get_dct_n(dct_sh, index, n)
    dct_n = zeros(1,n);
    for i=1:n
        while (~dct_sh(index))
            index = index + 1;
        end
        dct_n(i) = index;
        index = index + 1;
    end
end
