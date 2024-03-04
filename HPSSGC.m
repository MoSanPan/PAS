clc
data = xlsread('CZC1');
Q = (data');
epsilon = 0.02;
W = 10000;
T = 50000;            
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
 %% 
YSYS = [0.023,  0.033,  0.043, 0.053, 0.063];
%%  
for ysys = 1:5
    epsilon =  YSYS(ysys);
    JFC = 0;
for t = 1:T
  
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

    if(t >= W)
            for t1 = t-W+1:t
                ZS1 = ZS1 + data1(t1);
            end
    elseif(t < W && t >= 1) 
            for t1 = 1:t
                ZS1 = ZS1 + data1(t1);
            end 
    end
 
    if(t >= W)
            for t1 = t-W+1:t
                ZS2 = ZS2 + data2(t1);
            end
    elseif(t < W&&t >= 1) 
            for t1 = 1:t
                ZS2 = ZS2 + data2(t1);
            end 
    end
    

    if(t >= W)
            for t1 = t-W+1:t
                ZS3 = ZS3 + data3(t1);
            end
    elseif(t < W&&t >= 1) 
            for t1 = 1:t
                ZS3 = ZS3 + data3(t1);
            end 
    end
    
  
    if(t >= W)
            for t1 = t-W+1:t
                ZS4 = ZS4 + data4(t1);
            end
    elseif(t < W&&t >= 1) 
            for t1 = 1:t
                ZS4 = ZS4 + data4(t1);
            end 
    end
    
   
    if(t >= W)
            for t1 = t-W+1:t
                ZS5 = ZS5 + data5(t1);
            end
    elseif(t < W&&t >= 1) 
            for t1 = 1:t
                ZS5 = ZS5 + data5(t1);
            end 
    end

    if(t >= W)
            for t1 = t-W+1:t
                ZS6 = ZS6 + data6(t1);
            end
    elseif(t < W&&t >= 1) 
            for t1 = 1:t
                ZS6 = ZS6 + data6(t1);
            end 
    end

  
%%
ZS = [ZS1,ZS2,ZS3,ZS4,ZS5,ZS6];
GJ = ZS;
[D,b] = sort(GJ);

%%
SY = 0;SY1 = 1;H = D;J = 2;T1 = 6;

sensitivity = 1; 
delta = 10^-5;
A = zeros(T1,T1);                 
m = 1;n = 1;A(m,n) = H(1);
while J <= T1
    A(m,n+1) = H(J); 
    X = var(A(m,1:n+1),1)*(n+1)+2*(1)^2/((n+1)*(epsilon^2));                             
    Y = var(A(m,1:n),1)*n +2*(1)^2/(n*(epsilon^2)) + 2*(1)^2/((T1-J+1)^2*(epsilon^2));   
    if (X < Y)          
        n = n + 1;
    else
        SY = SY + n;
      
        while SY1 <= SY
        sigma = n*epsilon;
     
        scale = sensitivity * sqrt(2 * log(1.25 / delta)) / sigma;
        u = normrnd(0, scale);
     
        GJ(b(SY1)) = sum(A(m,1:n))/n + u;
        SY1 = SY1 + 1;
        end     
        A(m,n+1) = 0; 
        m = m + 1;
        n = 1;
        A(m,n) = H(J);
    end
    J = J + 1;
end

SY = SY + n;

while SY1 <= SY
        sigma =  n*epsilon;
        scale = sensitivity * sqrt(2 * log(1.25 / delta)) / sigma;
        u = normrnd(0, scale);
 
        GJ(b(SY1)) = sum(A(m,1:n))/n + u;
        SY1 = SY1 + 1;
end
GJ(GJ<0) = 0;
JFWC = sqrt(sum((ZS-GJ).^2)/6);

JFC = JFC + JFWC;
end
fprintf('HPSSGC的均方差为%.4f\n',JFC/T);
end