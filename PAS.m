clc %清空命令
tic %开始计时
%% 数据处理过程
PJwC=0;                  %平均误差
data = xlsread('CZC1');  %读取数据
Q = (data');             %Q存储CZC数据集中数据
JFC = 0;
CFCS = 30;
for CS = 1:CFCS
s = 20000;                 
w = 50000;                 
T2 = 100000;               
Sample_set = zeros(2,s);   
B = zeros(2,w);

for t = 1:T2
   if( t <= s )
     
       Sample_set(1,t) = t;
       Sample_set(2,t) = Q(t);
   elseif(t > s && t <= w)
  
       r =  randi([1, t], 1, 1);
       if(r <= s)
           Sample_set(1,r) = t;
           Sample_set(2,r) = Q(t);
       end
   elseif(t > w)
    
       indices = find(Sample_set(1, :) < t - w + 1);
       if isempty(indices)
            disp('no elements');
            index = 0; 
            r2 = randi([1, w], 1, 1);
            if(r <= s)
               Sample_set(1,r) = t;
               Sample_set(2,r) = Q(t);
            end
       else
            disp(['<t-w index：', num2str(indices(1))]);
            index = indices(1);
            Sample_set(1,index) = t;
            Sample_set(2,index) = Q(t);
       end
   end
   %%
      if(t <=w )
             B(t) = Q(t);
      elseif(t > w)
            
             B(1:1:w-1) = B(2:1:w);
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
      MSE = sqrt(sum((ZS-GJ).^2)/1);
      JFC = JFC + MSE;
end
end
fprintf('均方差为%.4f\n',JFC/T2/CFCS);