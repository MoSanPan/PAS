clc %清空命令
tic %开始计时
%% 数据处理过程
PJwC=0;                  %平均误差
data = xlsread('CZC1');  %读取数据
Q = (data');             %Q存储CZC数据集中数据
JFC = 0;
CFCS = 10;
for CS = 1:CFCS
s = 20000;                   %采样集合s
w = 50000;                  %滑动窗口大小
T2 = 100000;                 %所需要查询的数据时刻
Sample_set = zeros(2,s);   %采样集合
B = zeros(2,w);

for t = 1:T2
   %% 估计计数
   if( t <= s )
       %小于采样结集合, 全部存储下来
       Sample_set(1,t) = t;
       Sample_set(2,t) = Q(t);
   elseif(t > s && t <= w)
       %在s-w之间的集合
       r =  randi([1, t], 1, 1);
       if(r <= s)
           Sample_set(1,r) = t;
           Sample_set(2,r) = Q(t);
       end
   elseif(t > w)
       %当超过w之后,首先判断当前采样集合中是否有数据过期，如果没有过期
       indices = find(Sample_set(1, :) < t - w + 1);
       if isempty(indices)
            disp('没有找到匹配的元素。');
            index = 0; % 没有找到时将索引设为0,则表示当前采样集合没有数据过期，那么我们需要去随机替换。
            r2 = randi([1, w], 1, 1);
            if(r <= s)
               Sample_set(1,r) = t;
               Sample_set(2,r) = Q(t);
            end
       else
            disp(['小于t-w的时间戳的元素在矩阵中的索引是：', num2str(indices(1))]);
            index = indices(1); % 如果有多个匹配，仅取第一个匹配的索引
            Sample_set(1,index) = t;
            Sample_set(2,index) = Q(t);
       end
   end
   %%
   %% 真实计算
      if(t <=w )
             B(t) = Q(t);
      elseif(t > w)
             %当超过w之后
             B(1:1:w-1) = B(2:1:w);%将当前数据2-w个数据移动到1-w-1的位置上
             B(w) = Q(t);
      end
      ZS = sum(B(:) == 1);
      if( t <= s )
         GJ = sum(Sample_set(:) == 1) ;
      elseif(t > s && t <= w)
         GJ = sum(Sample_set(:) == 1)*t/s;
      elseif(t > w)
         GJ = sum(Sample_set(:) == 1)*w/s;
      end
      %fprintf('ZS = %f, GJ =  = %f',ZS, GJ);
      %fprintf('\n');
    %%
      MSE = sqrt(sum((ZS-GJ).^2)/1);
      JFC = JFC + MSE;
end
 fprintf('均方差为%.4f\n',JFC/T2);
end
fprintf('均方差为%.4f\n',JFC/T2/CFCS);