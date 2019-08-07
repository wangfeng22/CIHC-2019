clear all;clc;
addpath(genpath(pwd));
%--------------------------------------------------------------------------
tic;
n=1;%对n幅图像隐写
payload=0.5;
QF=75;

image_name = 'Lena.jpg';%获取该文件夹中所有jpg格式的图像
% matlabpool local 4
for i=1:n
    COVER=image_name;
    STEGO=['stego_',image_name];
    S_STRUCT = J_UNIWARD(COVER,payload);
    temp = load(strcat('default_gray_jpeg_obj_', num2str(QF), '.mat'));
    default_gray_jpeg_obj = temp.default_gray_jpeg_obj;
    C_STRUCT = default_gray_jpeg_obj;
    C_STRUCT.coef_arrays{1} = S_STRUCT.coef_arrays{1};
    jpeg_write(C_STRUCT,STEGO);
    fprintf(['第 ',num2str(i),' 幅图像-------- ok','\n']);
end
% matlabpool close;
toc;
%--------------------------------------------------------------------------