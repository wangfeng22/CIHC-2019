clear all;clc;
addpath(genpath(pwd));
tic;
% matlabpool local 12
n=1;%¶Ôn·ùÍ¼ÏñÒþÐ´
payload=0.1;
QF=75;

image_name = 'Lena.jpg';

for i=1:n
    COVER='Lena.jpg';
    STEGO=['stego_',image_name];
    S_STRUCT = UERD(COVER,payload);
    temp = load(strcat('default_gray_jpeg_obj_', num2str(QF), '.mat'));
    default_gray_jpeg_obj = temp.default_gray_jpeg_obj;
    C_STRUCT = default_gray_jpeg_obj;
    C_STRUCT.coef_arrays{1} = S_STRUCT.coef_arrays{1};
    jpeg_write(C_STRUCT,STEGO);
    fprintf(['µÚ ',num2str(i),' ·ùÍ¼Ïñ-------- ok','\n']);
end
% matlabpool close
toc;
% -------------------------------------------------------------------------