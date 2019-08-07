function [ H ] = create_pcm_from_submatrix( H_hat, k )

if size(H_hat,1)==1
    tmp = zeros(32,size(H_hat,2));
    for i = 1:size(H_hat,2)
        tmp(:,i) = dec2binvec(H_hat(i), 32)';
    end
    H_hat = tmp(1:find( sum(tmp,2)>0, 1, 'last'),:);
end

H = zeros(1);
[n m] = size(H_hat);
for i=1:k
    H(i:(i+n-1),(m*(i-1)+1):(m*i)) = H_hat;
end
end
