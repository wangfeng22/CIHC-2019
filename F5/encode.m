function dct_encode = encode(dct_sh, cipherbit)
    nonzero = sum(sum(dct_sh~=0));
    [cnt len] = size(cipherbit);
    ciphernum = cnt*len;

    [n k] = calc(nonzero, ciphernum);

    ciphernum_align = ceil(ciphernum/k)*k;
    cipherbit_align = char(ones(1,ciphernum_align)*'0');
    cipherbit_align(1:cnt*len) = cipherbit';

    dct_encode = dct_sh;
    index = 1;
    i = 1;
    while (i<ciphernum_align)
        [dct_encode index flag] = encode_ex(dct_encode, index, n, cipherbit_align(i:i+k-1));
        if (flag)
            i = i+k;
        end
    end
end

function [dct_encode index flag] = encode_ex(dct_encode, index, n, cipherbit)
    dct_n = get_dct_n(dct_encode, index, n);
    fa = mod(dct_encode(dct_n(1)),2);
    for i=2:n
        fa = bitxor(fa, mod(dct_encode(dct_n(i)),2)*i);
    end
    x = bin2dec(cipherbit);
    y = bitxor(x, fa);
    flag = 1;
    if (y)
        ay = mod(dct_encode(dct_n(y)),2);
        if (ay)
            dct_encode(dct_n(y)) = dct_encode(dct_n(y))-1;
        else
            dct_encode(dct_n(y)) = dct_encode(dct_n(y))+1;
        end
        flag = dct_encode(dct_n(y));
    end
    if (flag)
        index = dct_n(end) + 1;
    end
end

function dct_n = get_dct_n(dct_encode, index, n)
    dct_n = zeros(1,n);
    for i=1:n
        while (~dct_encode(index))
            index = index + 1;
        end
        dct_n(i) = index;
        index = index + 1;
    end
end
