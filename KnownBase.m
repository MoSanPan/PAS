clc %清空命令
%% 
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
YSYS = [0.02, 0.04, 0.06, 0.08, 0.1];
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

   YZ = 0.9;
   noisy_data = zeros(size(ZS));
   for i = 1:length(ZS)
        sensitivity = 1; 
        scale = sensitivity * sqrt(2 * log(1.25 / delta)) / epsilon;
        noise = normrnd(0, scale);
        noisy_data(i) = ZS(i) + noise;
   end
   GJ = noisy_data;
   JFWC = sqrt(sum(abs(ZS-GJ).^2)/6)*YZ;
   JFC = JFC + JFWC;   
end
end
fprintf('KnownBase均方差为%.4f\n',JFC/T2/CFCS);
end