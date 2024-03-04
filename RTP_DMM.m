clc %�������
%% ���ݴ������
PJWC=0;                  %ƽ�����
data = xlsread('CZC1');  %��ȡ����
Q = (data');             %Q�洢CZC���ݼ�������
W = 10000;                  %�������ڴ�С
T2 = 50000;               %����Ҫ��ѯ������ʱ��
A = zeros(1,W);

sensitivity = 1;

%YSYS = [0.02, 0.04, 0.06, 0.08, 0.1];

YSYS = [0.04, 0.023,  0.0165, 0.013, 0.011];
%YSYS = [0.018, 0.023,   0.028, 0.033, 0.04];
YSYS = [0.023,  0.033,  0.043, 0.053, 0.063];
delta = 10^-5;
CFCS = 1;
for ysys = 1:5
    epsilon =  YSYS(ysys);
    JFC = 0;
for CS = 1:CFCS
for t = 1:T2
   if( t <=W )
       A(t) = Q(t);
   elseif(t > W)
       %������W֮��
       A(1:1:W-1) = A(2:1:W);%����ǰ����2-W�������ƶ���1-W-1��λ����
       A(W) = Q(t); 
   end
   ZS = arrayfun(@(x) sum(A(:) == x), 1:6);
   % 0.0175,  0.01,  0.007, 0.005, 0.0035
   noisy_data = zeros(size(ZS));
    for i = 1:length(ZS)
        sensitivity = 1;  % �������жȣ������Ϊ1
        scale = sensitivity * sqrt(2 * log(3 / delta)) / epsilon;
        noise = normrnd(0, scale);
        %fprintf('����ֵΪ��%f',noise);fprintf('\n');
        noisy_data(i) = ZS(i) + noise;
    end
   GJ = noisy_data;
   JFWC = sqrt(sum(abs(ZS-GJ).^2)/6);
   JFC = JFC + JFWC;   
end
%fprintf('������Ϊ%.4f\n',JFC/T2);
end
fprintf('ZCZ_RTP_DMM������Ϊ%.4f\n',JFC/T2/CFCS);
end