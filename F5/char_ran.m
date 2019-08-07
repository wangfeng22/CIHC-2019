function cipher = char_ran(len)

a=zeros(1,len);
for i=1:len
    a(i)=ceil(95*rand(1))+32;
end
cipher = char(a);
end