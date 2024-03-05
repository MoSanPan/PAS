clc %清空命令
%% 数据处理过程
PJWC=0;                  %平均误差
data = xlsread('CZC1');  %读取数据
Q = (data');             %Q存储CZC数据集中数据
w = 10000;                  %滑动窗口大小
T2 = 50000;               %所需要查询的数据时刻
A = zeros(1,w);

sensitivity = 1;
epsilon = 1.0;
%YSYS = [0.02, 0.04, 0.06, 0.08, 0.1];

YSYS = [0.04, 0.023,  0.0165, 0.013, 0.011];
delta = 10^-5;
CFCS = 1;

% 所有分组区间的数据流 
data1 = zeros(1,T2);   
data2 = zeros(1,T2);
data3 = zeros(1,T2);
data4 = zeros(1,T2);
data5 = zeros(1,T2);
data6 = zeros(1,T2);

for i=1:T2
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
end

for t = 1:T2
    if( t <= w )
       A(t) = Q(t);
    elseif(t > w)
       %当超过W之后
       A(1:1:w-1) = A(2:1:w);%将当前数据2-w个数据移动到1-w-1的位置上
       A(w) = Q(t); 
    end
    % 原始数据
    original_data = arrayfun(@(x) sum(A(:) == 6), 1:6);
    % 优化基数以获得最低的总体方差
    optimized_scale = optimize_scale_parameter(original_data, epsilon);

    % 添加噪音
    gaussian_noise = Gaussian_noise(optimized_scale, delta, epsilon);

    % 对每个数据点添加噪音
    noisy_data = original_data + gaussian_noise;

    JFWC = sqrt(sum((noisy_data-original_data).^2));
    JFC = JFC + JFWC;   
end
fprintf('均方差为%.4f\n',JFC/T2);