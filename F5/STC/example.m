clear all;clc;
addpath(fullfile('STC'));
addpath(fullfile('Jpeg_toolbox'));
tic;
% matlabpool local 12
n=800;%对n幅图像隐写
payload=0.4;
%QF=75;
image_path=['C:\Users\mayn\Desktop\隐写数据\image'];% 图像文件夹路径
img_path_list = dir(fullfile(image_path,'*.pgm'));%获取该文件夹中所有pgm格式的图像
file_path=['C:\Users\mayn\Desktop\隐写数据\dense_result']%可能性矩阵的路径
file_path_list=dir(fullfile(file_path,'*.txt'));
for i=1:n
    image_name = img_path_list(i).name;%图像名
    %class(image_name)
    %COVER=strcat(image_path,image_name);
    file_name=file_path_list(i).name;
    img_name=regexp(image_name,'\.','split');
    fi_name=regexp(file_name,'\.','split');
    if strcmp(img_name(1),fi_name(1))
        img_name(1)
        COVER=fullfile(image_path,image_name);
        possible=fullfile(file_path,file_name);
    %STEGO=['E:\MATLABR2016bworkspace\20180719\C' num2str(n) '\stego' num2str(QF) '_'  num2str(payload) '_zhang' '\',image_name];
        try
            [S_STRUCT,error] = Residual_Block_JS(COVER,possible,payload);
            error
            name=char(strcat(img_name(1),'.png'));

            path=['C:\Users\mayn\Desktop\隐写数据\dense_stego'];
            path=fullfile(path,name);
            im=uint8(S_STRUCT);
            imwrite(im,path);
            fprintf(['第 ',num2str(i),' 幅图像-------- ok','\n']);
        end
    end
end
% matlabpool close
toc;
% -------------------------------------------------------------------------