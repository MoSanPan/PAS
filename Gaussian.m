function noise = Gaussian( delta, epsilon)
    sensitivity = 1;  % 数据敏感度，这里简化为1
        scale = sensitivity * sqrt(2 * log(3 / delta)) / epsilon;
        noise = normrnd(0, scale);
end 

