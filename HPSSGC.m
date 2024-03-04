%这里是将数据进行分数组的形式，我们将其展开。在一个时间段中-1-90岁出车祸的事故
%区间为6
%%
clc
data = xlsread('CZC1');
Q = (data');
epsilon = 0.02;
W = 10000;
T = 50000;                                                   %T:一个数组运行为（0，1）数据流的长度
% 所有分组区间的数据流 
data1 = zeros(1,T);   
data2 = zeros(1,T);
data3 = zeros(1,T);
data4 = zeros(1,T);
data5 = zeros(1,T);
data6 = zeros(1,T);
data7 = zeros(1,T);
data8 = zeros(1,T);
data9 = zeros(1,T);
data10 = zeros(1,T);

%将所有数据转化成二进制形式分组。
for i=1:T
    m = Q(i);
    if(m == 1)
        data1(i) = 1;
    else
        data1(i) = 0;
    end
    if(m == 2)
        data2(i) = 1;
    else
        data2(i) = 0;
    end
    if(m == 3)
        data3(i) = 1;
    else
        data3(i) = 0;
    end
    if(m == 4)
        data4(i) = 1;
    else
        data4(i) = 0;
    end
    if(m == 5)
        data5(i) = 1;
    else
        data5(i) = 0;
    end
    if(m == 6)
        data6(i) = 1;
    else
        data6(i) = 0;
    end
    if(m == 7)
        data7(i) = 1;
    else
        data7(i) = 0;
    end
    if(m == 8)
        data8(i) = 1;
    else
        data8(i) = 0;
    end
    if(m == 9)
        data9(i) = 1;
    else
        data9(i) = 0;
    end
    if(m == 10)
        data10(i) = 1;
    else
        data10(i) = 0;
    end
end
 JFC = 0 ;
 CPJ = 0;
 %epsilon = epsilon1-epsilon;
 %% 
 %YSYS = [0.02, 0.04, 0.06, 0.08, 0.1];
%YSYS = [0.04, 0.023,  0.0165, 0.013, 0.011];
%YSYS = [0.018, 0.023,   0.028, 0.033, 0.04];
YSYS = [0.023,  0.033,  0.043, 0.053, 0.063];
%%  
for ysys = 1:5
    epsilon =  YSYS(ysys);
    JFC = 0;
for t = 1:T
    %% 获取每一时刻的真实值  
    %初始化
    ZS1 = 0;
    ZS2 = 0;
    ZS3 = 0;
    ZS4 = 0;
    ZS5 = 0;
    ZS6 = 0;
    ZS7 = 0;
    ZS8 = 0;
    ZS9 = 0;
    ZS10 = 0;
    % 第一时刻
    if(t >= W)
            for t1 = t-W+1:t
                ZS1 = ZS1 + data1(t1);
            end
    elseif(t < W && t >= 1) 
            for t1 = 1:t
                ZS1 = ZS1 + data1(t1);
            end 
    end
    % 第二时刻
    if(t >= W)
            for t1 = t-W+1:t
                ZS2 = ZS2 + data2(t1);
            end
    elseif(t < W&&t >= 1) 
            for t1 = 1:t
                ZS2 = ZS2 + data2(t1);
            end 
    end
    
    % 第三时刻
    if(t >= W)
            for t1 = t-W+1:t
                ZS3 = ZS3 + data3(t1);
            end
    elseif(t < W&&t >= 1) 
            for t1 = 1:t
                ZS3 = ZS3 + data3(t1);
            end 
    end
    
    % 第四时刻
    if(t >= W)
            for t1 = t-W+1:t
                ZS4 = ZS4 + data4(t1);
            end
    elseif(t < W&&t >= 1) 
            for t1 = 1:t
                ZS4 = ZS4 + data4(t1);
            end 
    end
    
     % 第五时刻
    if(t >= W)
            for t1 = t-W+1:t
                ZS5 = ZS5 + data5(t1);
            end
    elseif(t < W&&t >= 1) 
            for t1 = 1:t
                ZS5 = ZS5 + data5(t1);
            end 
    end
    
    % 第六时刻
    if(t >= W)
            for t1 = t-W+1:t
                ZS6 = ZS6 + data6(t1);
            end
    elseif(t < W&&t >= 1) 
            for t1 = 1:t
                ZS6 = ZS6 + data6(t1);
            end 
    end

    % 第七时刻
    if(t >= W)
            for t1 = t-W+1:t
                ZS7 = ZS7 + data7(t1);
            end
    elseif(t < W&&t >= 1) 
            for t1 = 1:t
                ZS7 = ZS7 + data7(t1);
            end 
    end

    % 第八时刻
    if(t >= W)
            for t1 = t-W+1:t
                ZS8 = ZS8 + data8(t1);
            end
    elseif(t < W&&t >= 1) 
            for t1 = 1:t
                ZS8 = ZS8 + data8(t1);
            end 
    end

    if(t >= W)
            for t1 = t-W+1:t
                ZS9 = ZS9 + data9(t1);
            end
    elseif(t < W&&t >= 1) 
            for t1 = 1:t
                ZS9 = ZS9 + data9(t1);
            end 
    end

    if(t >= W)
            for t1 = t-W+1:t
                ZS10 = ZS10 + data10(t1);
            end
    elseif(t < W &&t >= 1) 
            for t1 = 1:t
                ZS10 = ZS10 + data10(t1);
            end 
    end
%%
ZS = [ZS1,ZS2,ZS3,ZS4,ZS5,ZS6];
GJ = ZS;
[D,b] = sort(GJ);%D:排序后矩阵,b:记录排序前的索引号
%fprintf('进行排序的结果:')
%disp(D);
%%
SY = 0;SY1 = 1;H = D;J = 2;T1 = 6;

  %加噪声部分
sensitivity = 1; 
delta = 10^-5;
A = zeros(T1,T1);                 %可以设置m,n对A进行行和列的审查（m = m + 1行;n = n + 1列;），表示有10*10的矩阵
m = 1;n = 1;A(m,n) = H(1);
while J <= T1
    A(m,n+1) = H(J); %提取某一行矩阵A(m,1:n+1)
    X = var(A(m,1:n+1),1)*(n+1)+2*(1)^2/((n+1)*(epsilon^2));                             %（C U H）重构误差+拉普拉斯误差          (表示合并的误差)   假设是1-n个矩阵加一列，变为1-n+1列矩阵,合并则表示err(c(i)+h(j))
    Y = var(A(m,1:n),1)*n +2*(1)^2/(n*(epsilon^2)) + 2*(1)^2/((T1-J+1)^2*(epsilon^2));    %（C + H）重构误差+拉普拉斯误差          (表示不合并的误差) 假设1-n个矩阵，不合并则表示err(c(i))+err(h(j)) 
    if (X < Y)          
        n = n + 1;%通过比较分组的误差的大小(合并的话可以通过在同一行进行加一列)   C(i) = [C(i),H(j)]
    else
        SY = SY + n;
        %fprintf('个数为%.4f',n);fprintf('\n');
        while SY1 <= SY
        sigma = n*epsilon;
        %加噪声部分
        scale = sensitivity * sqrt(2 * log(1.25 / delta)) / sigma;
        u = normrnd(0, scale);
       % fprintf('噪音值为：%f',u);fprintf('\n');
        GJ(b(SY1)) = sum(A(m,1:n))/n + u;
        SY1 = SY1 + 1;
        end     
        A(m,n+1) = 0; 
        m = m + 1;
        n = 1;
        A(m,n) = H(J);%C = [C,C(i)];（不合并的话可以将下一行来存储H（j）,扩充一个新行）(表示为 m = m + 1;n = n + 1;A(m;n) =H(j);
    end
    J = J + 1;
end
%fprintf('个数为%.4f',n);fprintf('\n');
SY = SY + n;

while SY1 <= SY
        sigma =  n*epsilon;
        scale = sensitivity * sqrt(2 * log(1.25 / delta)) / sigma;
        u = normrnd(0, scale);
     %   fprintf('噪音值为：%f',u);fprintf('\n');
        GJ(b(SY1)) = sum(A(m,1:n))/n + u;
        SY1 = SY1 + 1;
end
%disp(ZS);
%fprintf('\n');
%disp(GJ);
%fprintf('\n');
GJ(GJ<0) = 0;
JFWC = sqrt(sum((ZS-GJ).^2)/6);

JFC = JFC + JFWC;
% fprintf('均方差为%.4f',JFC);fprintf('\n');
end
fprintf('HPSSGC的均方差为%.4f\n',JFC/T);
end