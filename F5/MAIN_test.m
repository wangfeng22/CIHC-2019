%%% setup
clear all
addpath(genpath(pwd));
COVER = 'Lena.jpg'; % cover image (grayscale JPEG image)
jobj = jpeg_read(COVER);
STEGO = 'Lena_stego.jpg'; % resulting stego image that will be created
ALPHA = 0.25; % relative payload in terms of bits per nonzero AC DCT coefficient
SEED = 0.99; % PRNG seed for the random walk over the coefficients


tic;
files=1;
for i=1:length(files)
    fprintf('Processing the %d image: ',i);
    f5_simulation(COVER,STEGO,SEED,ALPHA);
    fprintf('ok\n');
end
T = toc;

fprintf('-----\n');
fprintf('F5 simulation finished\n');
fprintf('relative payload: %.4f bpac\n',ALPHA);