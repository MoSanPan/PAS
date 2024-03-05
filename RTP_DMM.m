clear;
clc;

clc %清空命令
%% 数据处理过程
PJWC=0;                  
data = xlsread('CZC1');  
Q = (data');             
window_size = 10000;     
T2 = 50000;              
A = zeros(1,window_size);

sensitivity = 1;
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
data = data1; 


%YSYS = [0.04, 0.023,  0.0165, 0.013, 0.011];
YSYS = [0.04];
for ysys = 1:length(YSYS)
    epsilon =  YSYS(ysys);
    JFC = 0;

current_window = zeros(1, window_size);
binary_tree = zeros(1, window_size * 2 - 1);
for i = 1:T2
    current_window(mod(i-1, window_size) + 1) = data(i);
    
    for j = 1:window_size
        binary_tree(window_size - 1 + j) = current_window(j);
        k = window_size - 1 + j;
        while k > 1
            parent = floor(k / 2);
            binary_tree(parent) = binary_tree(2 * parent) + binary_tree(2 * parent + 1);
            k = parent;
        end
    end
    
    disp(['time  ' num2str(i) ' count: ' num2str(binary_tree(1))]);

    ZS = num2str(binary_tree(1));
    noisy_data = zeros(size(ZS));
    for ZSJS = 1:length(ZS)
        noise = Gaussian(delta, epsilon);
        %fprintf('噪音值为：%f',noise);fprintf('\n');
        noisy_data(ZSJS) = ZS(ZSJS) + noise;
    end
    GJ = noisy_data;
    JFWC = sqrt(sum(abs(ZS-GJ).^2)/1);
    JFC = JFC + JFWC;   
end
fprintf('RTP_DMM均方差为%.4f\n',JFC/T2);
end
fprintf('RTP_DMM均方差为%.4f\n',JFC/T2/CFCS);
