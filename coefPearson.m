function [r] = coefPearson(x,y)
    n = length(x);
    x_med = mean(x);
    y_med = mean(y);
    cov_xy = sum((x - x_med) .* (y - y_med)) / (n - 1);
    devstd_x = sqrt(sum((x - x_med) .^ 2) / (n - 1));
    devstd_y = sqrt(sum((y - y_med) .^ 2) / (n - 1));
    r = cov_xy / (devstd_x * devstd_y);
end

