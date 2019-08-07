function [S_STRUCT,error] = Residual_Block_JS(coverPath, possible,payload)
possibles=load(possible);
possible0=1-possibles;
possibles=possibles./2;
cover=double(imread(coverPath));
[k,l]=size(cover);
hw=k*l;
%C_STRUCT = jpeg_read(coverPath);
%QUANT=C_STRUCT.quant_tables{1};
%C_COEFFS = C_STRUCT.coef_arrays{1};
%nzAC = nnz(C_COEFFS)-nnz(C_COEFFS(1:8:end,1:8:end));
hidden_message=double(rand(1,round(payload * hw))<0.5);
%[k,l] = size(C_COEFFS);
costP=log((1./possibles)-2);
costM=log((1./possibles)-2);
cost0=log((1./possible0)-2);
%--------------------
wetConst=10^13;
%costP(isnan(costP)) = wetConst;
%costM(isnan(costM)) = wetConst;
costP(costP > wetConst) = wetConst;
costM(costM > wetConst) = wetConst;
cost0(cost0 > wetConst) = wetConst;
costP(costP < -wetConst) = -wetConst;
costM(costM < -wetConst) = -wetConst;
cost0(cost0 < -wetConst) = -wetConst;
%costP(C_COEFFS > 1023) = wetConst;
%costM(C_COEFFS < -1023) = wetConst;

cover=cover(:);
costs=zeros(3,k*l,'single');
costs(1,:)=costM(:);
costs(2,:)=cost0(:);
costs(3,:)=costP(:);
%% --------------------------- 信息嵌入 ------------------------------------
[~,stego,n_msg_bits,~] = stc_pm1_pls_embed(int32(cover)',costs,uint8(hidden_message),10);%信息嵌入
extr_msg = stc_ml_extract(stego, n_msg_bits,10);%信息提取
error=sum(hidden_message~=double(extr_msg));%验证信息是否正确嵌入
%S_STRUCT = cover;
stego=reshape(stego,[k l]);
stego=double(stego);
S_STRUCT= stego;%.coef_arrays{1} = stego;
end

function plane=prediction(X)
[k,l] = size(X);
plane=zeros(k,l);
for i=1:k
    for j=1:l
        if i-1>0 && i+1<=k && j-1>0 && j+1<=l
            plane(i,j)=(X(i,j-1)+X(i,j+1)+X(i-1,j)+X(i+1,j))/4;
        elseif i-1>0 && i+1<=k && j-1>0
            plane(i,j)=(X(i,j-1)+X(i-1,j)+X(i+1,j))/3;
        elseif i-1>0 && i+1<=k && j+1<=l
            plane(i,j)=(X(i,j+1)+X(i-1,j)+X(i+1,j))/3;
        elseif i-1>0 && j-1>0 && j+1<=l
            plane(i,j)=(X(i,j-1)+X(i,j+1)+X(i-1,j))/3;
        elseif i+1<=k && j-1>0 && j+1<=l
            plane(i,j)=(X(i,j-1)+X(i,j+1)+X(i+1,j))/3;
        elseif i+1<=k && j+1<=l
            plane(i,j)=(X(i,j+1)+X(i+1,j))/2;
        elseif i+1<=k && j-1>0
            plane(i,j)=(X(i+1,j)+X(i,j-1))/2;
        elseif i-1>0 && j+1<=l
            plane(i,j)=(X(i,j+1)+X(i-1,j))/2;
        else
            plane(i,j)=(X(i,j-1)+X(i-1,j))/2;
        end
    end
end
end