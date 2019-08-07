function f5_simulation(COVER,STEGO,SEED,ALPHA)
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% This program simulates the embedding impact of the steganographic
% algorithm F5 as if the best possible coding was used. 
% -------------------------------------------------------------------------
% Input:
%  COVER - cover image (grayscale JPEG image)
%  STEGO - resulting stego image that will be created
%  ALPHA - relative payload in terms of bits per nonzero AC DCT coefficient
%  SEED - PRNG seed for the random walk over the coefficients
%--------------------------------------------------------------------------

%%% load the cover image
try
    jobj = jpeg_read(COVER); % JPEG image structure
    DCT = jobj.coef_arrays{1}; % DCT plane
catch
    error('ERROR (problem with the cover image)');
end
%--生成秘密信息,秘密信息以字符形式生成，
nonzero = sum(sum(DCT~=0));
len = round(nonzero*ALPHA/7);
ciphertext = char_ran(len);
cipherbit = dec2bin(ciphertext);
%-------------
dct_sh = shuffle(DCT, SEED);
dct_encode = encode(dct_sh, cipherbit);
dct_antish = antishuffle(dct_encode, SEED);

%%% save the resulting stego image
try
    jobj.coef_arrays{1} = dct_antish;
    jobj.optimize_coding = 1;
    jpeg_write(jobj,STEGO);
catch
    error('ERROR (problem with saving the stego image)')
end


