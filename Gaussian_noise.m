% 高斯噪音机制函数
function gaussian_noise = Gaussian_noise( sensitivity, delta, epsilon)
     scale = sensitivity * sqrt(2 * log(3 / delta)) / epsilon;
     gaussian_noise = normrnd(0, scale);
end