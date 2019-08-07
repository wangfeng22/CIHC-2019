%% EXAMPLE OF MULTI-LAYERED EMBEDDING - +-2 DISTORTION LIMITED SENDER
% implemented using syndrome-trellis codes
clc; clear;

n = 1e+5; % use n pixels
m = n/2;  % embed m bits
h = 10;   % use STCs with constraint_height = 10. Try values between 7 and 12.

cover = int32(256*rand(1,n));  % generate random cover pixels
msg = uint8(rand(1,m));        % generate m random message bits

% cost can be defined arbitrarily, this is just a simple example
costs = zeros(5, n, 'single'); % for each pixel, assign cost of being changed
costs(:,1) = [1e+5 100 0 1 5]; % cost of changing the first cover pixel by -2, -1, 0, +1, +2
costs([1 5],2:end) = 4;        % cost of changing pixels by -2 and +2
costs([2 4],2:end) = 1;        % cost of changing pixels by -1 and +1

l = 0.08;           % expected coding loss
target_dist = 1000; % target distortion in the distortion-limited sender
[d stego n_msg_bits l] = stc_pm2_dls_embed(cover, costs, msg, target_dist, l, h);
extr_msg = stc_ml_extract(stego, n_msg_bits, h);

if all(extr_msg==msg(1:sum(n_msg_bits)))
    fprintf('Message was embedded and extracted correctly.\n');
    fprintf('  %d bits embedded => %d bits in 3LSB, %d bits in 2LSB and %d bits in LSB.\n', ...
        sum(n_msg_bits), n_msg_bits(1), n_msg_bits(2), n_msg_bits(3));
    fprintf('  achieved coding_loss = %4.2f%%\n', l*100);
    fprintf('  distortion caused by embedding = %g required = %g\n', d, target_dist);
end
