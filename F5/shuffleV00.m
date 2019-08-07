%图像置乱程序

%作者：ltx1215
%日期：2010年8月7日
%采用的是混沌置乱算法
clear;
[filename, pathname] = uigetfile('*.jpg', '打开原始图像')
filename= [pathname filename];
J=imread(filename);
info=imfinfo(filename);
[m,n,p]=size(J);

%产生混沌序列
x(1)=0.5;
for i=1:m*n-1
    x(i+1)=3.7*x(i)*(1-x(i));
end
[y,num]=sort(x);%将产生的混沌序列进行排序
%如果原图为灰度图
if info.BitDepth==8
    
    Scambled=uint8(zeros(m,n));%产生一个与原图大小相同的0矩阵
    for i=1:m*n
        Scambled(i)=J(num(i));
    end
    
    
    %如果原图为二值图像
elseif info.BitDepth==1
    S=uint8(zeros(m,n));
    for i=1:m
        for j=1:n
            if J(i,j)==1
                S(i,j)=255;
            end
        end
    end
    Scambled=uint8(zeros(m,n));%产生一个与原图大小相同的0矩阵
    for i=1:m*n
        Scambled(i)=S(num(i));
    end
end

%如果为真彩图
if p==3
    Red=uint8(zeros(m,n));
    Green=uint8(zeros(m,n));
    Blue=uint8(zeros(m,n));
    RedNew=J(:,:,1);
    GreenNew=J(:,:,2);
    BlueNew=J(:,:,3);
    
    Scambled=uint8(zeros(m,n,p));%产生一个与原图大小相同的0矩阵
    for i=1:m*n
        Red(i)=RedNew(num(i));
        Green(i)=GreenNew(num(i));
        Blue(i)=BlueNew(num(i));
    end
    Scambled(:,:,1)=Red;
    Scambled(:,:,2)=Green;
    Scambled(:,:,3)=Blue;
end
imwrite(Scambled,'Scambled.jpg','quality',100);
imshow(Scambled);


%图像反置乱程序
%作者：ltx1215
%10年8月10日
[filename, pathname] = uigetfile('*.jpg', '打开原始图像')
filename= [pathname filename];
J=imread(filename);
info=imfinfo(filename);
[m,n,p]=size(J);

%产生混沌序列
x(1)=0.5;
for i=1:m*n-1
    x(i+1)=3.7*x(i)*(1-x(i));
end
[y,num]=sort(x);%将产生的混沌序列进行排序
%如果原图为灰度图
if info.BitDepth==8
    IScamble=uint8(zeros(m,n));%产生一个与原图大小相同的0矩阵
    for i=1:m*n
        IScamble(num(i))=J(i);
     end
    %如果原图为二值图像
elseif info.BitDepth==1
    S=uint8(zeros(m,n));
    for i=1:m        
        for j=1:n            
            if J(i,j)==1                
                S(i,j)=255;                
            end            
        end        
    end    
    IScamble=uint8(zeros(m,n));%产生一个与原图大小相同的0矩阵    
    for i=1:m*n        
        IScamble(num(i))=S(i);        
    end    
end

%如果为真彩图
if p==3    
    Red=uint8(zeros(m,n));    
    Green=uint8(zeros(m,n));    
    Blue=uint8(zeros(m,n));    
    RedNew=J(:,:,1);    
    GreenNew=J(:,:,2);    
    BlueNew=J(:,:,3);   
    IScamble=uint8(zeros(m,n,p));%产生一个与原图大小相同的0矩阵    
    for i=1:m*n        
        Red(num(i))=RedNew(i);        
        Green(num(i))=GreenNew(i);        
        Blue(num(i))=BlueNew(i);        
    end    
    IScamble(:,:,1)=Red;    
    IScamble(:,:,2)=Green;    
    IScamble(:,:,3)=Blue;    
end
imwrite(IScamble,'IScambled.jpg','quality',100);
imshow(IScamble);
