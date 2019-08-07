function draw_pcm( H_hat, k, grid_period )
%DRAW_PCM draw parity check matrix in black and white
%
% Tomas Filler (tomas.filler@binghamton.edu)
% http://dde.binghamton.edu/filler

%% parse input arguments
if nargin==1
    k = 1;
    H = H_hat;
else
    H = create_pcm_from_submatrix(H_hat, k);
end
if nargin<3
    grid_period = 1;
end
%% draw graph
clf; hold on;
[n m] = size(H);
imagesc(~H);
colormap gray;
axis image;

for i=grid_period:grid_period:n
    line([0 m+1], i+[0.5 0.5], 'Color', 0*[1 1 1])
end
for i=grid_period:grid_period:m
    line(i+[0.5 0.5], [0 n+1], 'Color', 0*[1 1 1])
end
ylim([0.5 n+0.5])

set(gca,'ydir','reverse');
end
