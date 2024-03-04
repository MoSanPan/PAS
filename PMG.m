clc %清空命令
%% 数据处理过程
PJWC=0;                  %平均误差
data = xlsread('CZC1');  %读取数据
Q = (data');             %Q存储CZC数据集中数据
W = 10000;                  %滑动窗口大小
T2 = 50000;               %所需要查询的数据时刻
A = zeros(1,W);

sensitivity = 1;
epsilon =  0.02;
delta = 10^-5;
CFCS = 1;
%YSYS = [0.02, 0.04, 0.06, 0.08, 0.1];
%YSYS = [0.04, 0.023,  0.0165, 0.013, 0.011];
YSYS = [0.018, 0.023,   0.028, 0.033, 0.04];
YSYS = [0.023,  0.033,  0.043, 0.053, 0.063];
for ysys = 1:5
    epsilon =  YSYS(ysys);
    JFC = 0;
for CS = 1:CFCS
for t = 1:T2
   if( t <=W )
       A(t) = Q(t);
   elseif(t > W)
       %当超过W之后
       A(1:1:W-1) = A(2:1:W);%将当前数据2-W个数据移动到1-W-1的位置上
       A(W) = Q(t); 
   end
   ZS = arrayfun(@(x) sum(A(:) == x), 1:6);
   % 0.0175,  0.01,  0.007, 0.005, 0.0035
 
   noisy_data = zeros(size(ZS));
   for i = 1:length(ZS)
        sensitivity = 1;  % 数据敏感度，这里简化为1
        scale = sensitivity * sqrt(2 * log(1.25 / delta)) / epsilon;
        noise = normrnd(0, scale);
        if(ZS(i)== 0)
           noisy_data(i) = 0;
        else
        %fprintf('噪音值为：%f',noise);fprintf('\n');
        noisy_data(i) = ZS(i) + noise;
        end

   end
   GJ = noisy_data;
   GJ(GJ<0) = 0;
   JFWC = sqrt(sum(abs(ZS-GJ).^2)/6);
   JFC = JFC + JFWC;   
end
%fprintf('均方差为%.4f\n',JFC/T2);
end
fprintf('PMG均方差为%.4f\n',JFC/T2/CFCS);
end