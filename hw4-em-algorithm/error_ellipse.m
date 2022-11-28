function error_ellipse(cov_mat, mu)
% ERROR_ELLIPSE plots the error ellipse given covariance matrix, and
% centers for a confidence level of 95%
% 
% Modified from https://www.mathworks.com/matlabcentral/fileexchange/4705-error_ellipse
% 

% chi squared quantile
k = 2.4477; % skipped the calculation here. For details see the url

n = 100; % Number of points around ellipse
p = 0 : pi / n : 2 * pi; % angles around a circle
[eigVec, eigVal] = eig(cov_mat);    % compute eigen vector and eigen values
xy = [cos(p'), sin(p')] * sqrt(eigVal) * eigVec'; % Transformation
x = xy(:, 1);
y = xy(:, 2);
plot((mu(1) + k * x), (mu(2) + k * y), LineWidth = 1.5);
end

