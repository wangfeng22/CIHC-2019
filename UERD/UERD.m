function S_STRUCT = UERD(coverPath, payload)

C_STRUCT = jpeg_read(coverPath);
QUANT=C_STRUCT.quant_tables{1};
C_COEFFS = C_STRUCT.coef_arrays{1};
nzAC = nnz(C_COEFFS)-nnz(C_COEFFS(1:8:end,1:8:end));
hidden_message=double(rand(1,round(payload * nzAC))<0.5);
[k,l] = size(C_COEFFS);
costP=zeros(k,l);
costM=zeros(k,l);
%--------------------
block=zeros(k,l);
for i=1:8:k
    for j=1:8:l
        tempblock=abs(C_COEFFS(i:i+7,j:j+7));
        tempblock(1,1)=0;
        temp=tempblock.*QUANT;
        block(i:i+7,j:j+7)=sum(temp(:));
    end
end
sub=block(1:8:end,1:8:end);
subdiff=prediction_diff(sub);
blockdiff=zeros(k,l);
u=1;v=1;
for i=1:8:k
    for j=1:8:l
        blockdiff(i:i+7,j:j+7)=abs(subdiff(u,v));
        v=v+1;
    end
    u=u+1;v=1;
end
QUANT(1,1)=(QUANT(1,2)+QUANT(2,1))/2;
for i=1:8:k
    for j=1:8:l
        costP(i:i+7,j:j+7)=QUANT;
        costM(i:i+7,j:j+7)=QUANT;
    end
end
costP=costP./(block+blockdiff);
costM=costM./(block+blockdiff);
costP=costP/min(costP(:));
costM=costM/min(costM(:));
wetConst=10^13;
costP(isnan(costP)) = wetConst;
costM(isnan(costM)) = wetConst;
costP(costP > wetConst) = wetConst;
costM(costM > wetConst) = wetConst;
costP(C_COEFFS > 1023) = wetConst;
costM(C_COEFFS < -1023) = wetConst;

cover=C_COEFFS(:);
costs=zeros(3,k*l,'single');
costs(1,:)=costM(:);
costs(3,:)=costP(:);
%% --------------------------- 信息嵌入 ------------------------------------
[~,stego,~,~] = stc_pm1_pls_embed(int32(cover)',costs,uint8(hidden_message),10);%信息嵌入
% extr_msg = stc_ml_extract(stego, n_msg_bits,10);%信息提取
% error=sum(hidden_message~=double(extr_msg));%验证信息是否正确嵌入
S_STRUCT = C_STRUCT;
stego=reshape(stego,[k l]);
stego=double(stego);
S_STRUCT.coef_arrays{1} = stego;
end

function plane=prediction_diff(X)
[k,l] = size(X);
plane=zeros(k,l);
for i=1:k
    for j=1:l
        if i-1>0 && i+1<=k && j-1>0 && j+1<=l
            plane(i,j)=(X(i,j-1)+X(i,j+1)+X(i-1,j)+X(i+1,j)+X(i+1,j+1)+X(i-1,j+1)+X(i+1,j-1)+X(i-1,j-1))/4;
        elseif i-1>0 && i+1<=k && j-1>0
            plane(i,j)=(X(i,j-1)+X(i-1,j)+X(i+1,j)+X(i+1,j-1)+X(i+1,j-1))/2.5;
        elseif i-1>0 && i+1<=k && j+1<=l
            plane(i,j)=(X(i,j+1)+X(i-1,j)+X(i+1,j)+X(i+1,j+1)+X(i-1,j+1))/2.5;
        elseif i-1>0 && j-1>0 && j+1<=l
            plane(i,j)=(X(i,j-1)+X(i,j+1)+X(i-1,j)+X(i-1,j-1)+X(i-1,j+1))/2.5;
        elseif i+1<=k && j-1>0 && j+1<=l
            plane(i,j)=(X(i,j-1)+X(i,j+1)+X(i+1,j)+X(i+1,j-1)+X(i+1,j+1))/2.5;
        elseif i+1<=k && j+1<=l
            plane(i,j)=(X(i,j+1)+X(i+1,j)+X(i+1,j+1))/1.5;
        elseif i+1<=k && j-1>0
            plane(i,j)=(X(i+1,j)+X(i,j-1)+X(i+1,j-1))/1.5;
        elseif i-1>0 && j+1<=l
            plane(i,j)=(X(i,j+1)+X(i-1,j)+X(i-1,j+1))/1.5;
        else
            plane(i,j)=(X(i,j-1)+X(i-1,j)+X(i-1,j-1))/1.5;
        end
    end
end
end