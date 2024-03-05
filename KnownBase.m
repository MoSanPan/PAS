clc %�������
%% ���ݴ������
PJWC=0;                  %ƽ�����
data = xlsread('CZC1');  %��ȡ����
Q = (data');             %Q�洢CZC���ݼ�������
w = 10000;                  %�������ڴ�С
T2 = 50000;               %����Ҫ��ѯ������ʱ��
A = zeros(1,w);

sensitivity = 1;
epsilon = 1.0;
%YSYS = [0.02, 0.04, 0.06, 0.08, 0.1];

YSYS = [0.04, 0.023,  0.0165, 0.013, 0.011];
delta = 10^-5;
CFCS = 1;

% ���з�������������� 
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
       %������W֮��
       A(1:1:w-1) = A(2:1:w);%����ǰ����2-w�������ƶ���1-w-1��λ����
       A(w) = Q(t); 
    end
    % ԭʼ����
    original_data = arrayfun(@(x) sum(A(:) == 6), 1:6);
    % �Ż������Ի����͵����巽��
    optimized_scale = optimize_scale_parameter(original_data, epsilon);

    % �������
    gaussian_noise = Gaussian_noise(optimized_scale, delta, epsilon);

    % ��ÿ�����ݵ��������
    noisy_data = original_data + gaussian_noise;

    JFWC = sqrt(sum((noisy_data-original_data).^2));
    JFC = JFC + JFWC;   
end
fprintf('������Ϊ%.4f\n',JFC/T2);