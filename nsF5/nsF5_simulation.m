function [nzAC,embedding_efficiency,changes] = nsf5_simulation(COVER,STEGO,ALPHA,SEED)

% Input:
%  COVER - cover image (grayscale JPEG image)
%  STEGO - resulting stego image that will be created
%  ALPHA - relative payload in terms of bits per nonzero AC DCT coefficient
%  SEED - PRNG seed for the random walk over the coefficients
% Output:
%  nzAC - number of nonzero AC DCT coefficients in the cover image
%  embedding_efficiency - bound on embedding efficiency used for simulation
%  changes - number of changes made

%%% load the cover image
try
    jobj = jpeg_read(COVER); % JPEG image structure
    DCT = jobj.coef_arrays{1}; % DCT plane
catch
    error('ERROR (problem with the cover image)');
end

if ALPHA>0
    %%% embedding simulation
    embedding_efficiency = ALPHA/invH(ALPHA);  % bound on embedding efficiency
    nzAC = nnz(DCT)-nnz(DCT(1:8:end,1:8:end)); % number of nonzero AC DCT coefficients
    % nzAC = nnz(DCT)-nnz(DCT(1:8:end,1:8:end))-nnz(DCT(DCT<2)); %
    changes = ceil(ALPHA*nzAC/embedding_efficiency); % number of changes nsF5 would make on bound
    changeable = (DCT~=0); % mask of all nonzero DCT coefficients in the image
    changeable(1:8:end,1:8:end) = false; % do not embed into DC modes
    % changeable(find(abs(DCT)<2)) = 0
    changeable = find(changeable); % indexes of the changeable coefficients
    rand('state',SEED); % initialize PRNG using given SEED
    changeable = changeable(randperm(nzAC)); % create a pseudorandom walk over nonzero AC coefficients
    to_be_changed = changeable(1:changes); % coefficients to be changed
    disp(to_be_changed)
    disp(size(DCT))
    DCT(to_be_changed) = DCT(to_be_changed)-sign(DCT(to_be_changed)); % decrease the absolute value of the coefficients to be changed
end

%%% save the resulting stego image
try
    jobj.coef_arrays{1} = DCT;
    jobj.optimize_coding = 1;
    jpeg_write(jobj,STEGO);
catch
    error('ERROR (problem with saving the stego image)')
end

function res = invH(y)
% inverse of the binary entropy function
to_minimize = @(x) (H(x)-y)^2;
res = fminbnd(to_minimize,eps,0.5-eps);

function res = H(x)
% binary entropy function
res = -x*log2(x)-(1-x)*log2(1-x);
