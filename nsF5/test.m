%%% setup
COVER = 'cover.jpg'; % cover image (grayscale JPEG image)
STEGO = 'stego.jpg'; % resulting stego image that will be created
ALPHA = 0.10; % relative payload in terms of bits per nonzero AC DCT coefficient
SEED = 15; % PRNG seed for the random walk over the coefficients

tic;
[nzAC,embedding_efficiency,changes] = nsf5_simulation(COVER,STEGO,ALPHA,SEED);
T = toc;

fprintf('-----\n');
fprintf('nsF5 simulation finished\n');
fprintf('cover image: %s\n',COVER);
fprintf('stego image: %s\n',STEGO);
fprintf('PRNG seed: %i\n',SEED);
fprintf('relative payload: %.4f bpac\n',ALPHA);
fprintf('number of nzACs in cover: %i\n',nzAC);
fprintf('embedding efficiency: %.4f\n',embedding_efficiency);
fprintf('number of embedding changes: %i\n',changes);
fprintf('elapsed time: %.4f seconds\n',T);
