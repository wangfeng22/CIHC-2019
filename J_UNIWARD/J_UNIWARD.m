function S_STRUCT = J_UNIWARD(coverPath, payload)

% -------------------------------------------------------------------------
% Copyright (c) 2013 DDE Lab, Binghamton University, NY.
% All Rights Reserved.
% -------------------------------------------------------------------------
% Permission to use, copy, modify, and distribute this software for
% educational, research and non-profit purposes, without fee, and without a
% written agreement is hereby granted, provided that this copyright notice
% appears in all copies. The program is supplied "as is," without any
% accompanying services from DDE Lab. DDE Lab does not warrant the
% operation of the program will be uninterrupted or error-free. The
% end-user understands that the program was developed for research purposes
% and is advised not to rely exclusively on the program for any reason. In
% no event shall Binghamton University or DDE Lab be liable to any party
% for direct, indirect, special, incidental, or consequential damages,
% including lost profits, arising out of the use of this software. DDE Lab
% disclaims any warranties, and has no obligations to provide maintenance,
% support, updates, enhancements or modifications.
% -------------------------------------------------------------------------
% Contact: vojtech_holub@yahoo.com | fridrich@binghamton.edu | February
% 2013
%          http://dde.binghamton.edu/download/stego_algorithms/
% -------------------------------------------------------------------------
% This function simulates embedding using J-UNIWARD steganographic 
% algorithm.
% -------------------------------------------------------------------------
% Input:  coverPath ... path to the image
%         payload ..... payload in bits per non zero DCT coefficient
% Output: stego ....... resulting JPEG structure with embedded payload
% -------------------------------------------------------------------------

C_SPATIAL = double(imread(coverPath));
C_STRUCT = jpeg_read(coverPath);
C_COEFFS = C_STRUCT.coef_arrays{1};
C_QUANT = C_STRUCT.quant_tables{1};

wetConst = 10^13;
sgm = 2^(-6);

%% Get 2D wavelet filters - Daubechies 8
% 1D high pass decomposition filter
hpdf = [-0.0544158422, 0.3128715909, -0.6756307363, 0.5853546837, 0.0158291053, -0.2840155430, -0.0004724846, 0.1287474266, 0.0173693010, -0.0440882539, ...
        -0.0139810279, 0.0087460940, 0.0048703530, -0.0003917404, -0.0006754494, -0.0001174768];
% 1D low pass decomposition filter
lpdf = (-1).^(0:numel(hpdf)-1).*fliplr(hpdf);

F{1} = lpdf'*hpdf;
F{2} = hpdf'*lpdf;
F{3} = hpdf'*hpdf;

%% Pre-compute impact in spatial domain when a jpeg coefficient is changed by 1
spatialImpact = cell(8, 8);
for bcoord_i=1:8
    for bcoord_j=1:8
        testCoeffs = zeros(8, 8);
        testCoeffs(bcoord_i, bcoord_j) = 1;
        spatialImpact{bcoord_i, bcoord_j} = idct2(testCoeffs)*C_QUANT(bcoord_i, bcoord_j);
    end
end

%% Pre compute impact on wavelet coefficients when a jpeg coefficient is changed by 1
waveletImpact = cell(numel(F), 8, 8);
for Findex = 1:numel(F)
    for bcoord_i=1:8
        for bcoord_j=1:8
            waveletImpact{Findex, bcoord_i, bcoord_j} = imfilter(spatialImpact{bcoord_i, bcoord_j}, F{Findex}, 'full');
        end
    end
end

%% Create reference cover wavelet coefficients (LH, HL, HH)
% Embedding should minimize their relative change. Computation uses mirror-padding
padSize = max([size(F{1})'; size(F{2})']);
C_SPATIAL_PADDED = padarray(C_SPATIAL, [padSize padSize], 'symmetric'); % pad image

RC = cell(size(F));
for i=1:numel(F)
    RC{i} = imfilter(C_SPATIAL_PADDED, F{i});
end

[k, l] = size(C_COEFFS);

nzAC = nnz(C_COEFFS)-nnz(C_COEFFS(1:8:end,1:8:end));
hidden_message=double(rand(1,round(payload * nzAC))<0.5);
rho = zeros(k, l);
tempXi = cell(3, 1);

%% Computation of costs
for row = 1:k
    for col = 1:l
        modRow = mod(row-1, 8)+1;
        modCol = mod(col-1, 8)+1;        
        
        subRows = row-modRow-6+padSize:row-modRow+16+padSize;
        subCols = col-modCol-6+padSize:col-modCol+16+padSize;
     
        for fIndex = 1:3
            % compute residual
            RC_sub = RC{fIndex}(subRows, subCols);            
            % get differences between cover and stego
            wavCoverStegoDiff = waveletImpact{fIndex, modRow, modCol};
            % compute suitability
            tempXi{fIndex} = abs(wavCoverStegoDiff) ./ (abs(RC_sub)+sgm);           
        end
        rhoTemp = tempXi{1} + tempXi{2} + tempXi{3};
        rho(row, col) = sum(rhoTemp(:));
    end
end

rhoM1 = rho;
rhoP1 = rho;

rhoP1(rhoP1 > wetConst) = wetConst;
rhoP1(isnan(rhoP1)) = wetConst;    
rhoP1(C_COEFFS > 1023) = wetConst;
    
rhoM1(rhoM1 > wetConst) = wetConst;
rhoM1(isnan(rhoM1)) = wetConst;
rhoM1(C_COEFFS < -1023) = wetConst;
        
cover=C_COEFFS(:);
costs=zeros(3,k*l,'single');
costs(1,:)=rhoM1(:);
costs(3,:)=rhoP1(:);
%% --------------------------- 信息嵌入 ------------------------------------
[~,stego,~,~] = stc_pm1_pls_embed(int32(cover)',costs,uint8(hidden_message),10);%信息嵌入
% extr_msg = stc_ml_extract(stego, n_msg_bits,10);%信息提取
% error=sum(hidden_message~=double(extr_msg));%验证信息是否正确嵌入
S_STRUCT = C_STRUCT;
stego=reshape(stego,[k l]);
stego=double(stego);
S_STRUCT.coef_arrays{1} = stego;
end
