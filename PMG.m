clc %清空命令
%% 数据处理过程
PJWC=0;                  
data = xlsread('CZC1');  
Q = (data');             
W = 10000;               
T2 = 50000;              
A = zeros(1,W);

sensitivity = 1;
epsilon =  0.02;
delta = 10^-5;
CFCS = 30;
YSYS = [0.023,  0.033,  0.043, 0.053, 0.063];
for ysys = 1:5
    epsilon =  YSYS(ysys);
    JFC = 0;
for CS = 1:CFCS
for t = 1:T2
   if( t <=W )
       A(t) = Q(t);
   elseif(t > W)
     
       A(1:1:W-1) = A(2:1:W);
       A(W) = Q(t); 
   end
   ZS = arrayfun(@(x) sum(A(:) == x), 1:6);
  
   noisy_data = zeros(size(ZS));
   for i = 1:length(ZS)
        sensitivity = 1;  
        scale = sensitivity * sqrt(2 * log(1.25 / delta)) / epsilon;
        noise = normrnd(0, scale);
        if(ZS(i)== 0)
           noisy_data(i) = 0;
        else
      
        noisy_data(i) = ZS(i) + noise;
        end

   end
   GJ = noisy_data;
   GJ(GJ<0) = 0;
   JFWC = sqrt(sum(abs(ZS-GJ).^2)/6);
   JFC = JFC + JFWC;   
end
end
fprintf('PMG均方差为%.4f\n',JFC/T2/CFCS);
end