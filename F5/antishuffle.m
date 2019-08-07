%图像反置乱程序
function y = antishuffle(x, key)
[m,n]=size(x);
%产生混沌序列
s=zeros(1,m*n);
s(1)=key;
for i=2:m*n
    s(i)=3.7*s(i-1)*(1-s(i-1));
end
%将产生的混沌序列进行排序
[~,num]=sort(s);
%产生一个与原图大小相同的0矩阵
y=zeros(m,n);
for i=1:m*n
    y(num(i))=x(i);
end
