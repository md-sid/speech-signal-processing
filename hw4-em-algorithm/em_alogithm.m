clc; clear; close all;
load('HW4_data.mat');

[N, d] = size(data);
nClusters = 7;
nIter = 50;
rng(0);     % for reproducibility

mu_m = data(randi(N, nClusters, 1), :); % inital mu values
pi_m = ones(1, nClusters) / nClusters;    % initial equally distributed probability
sigma_m = repmat(cov(data) / sqrt(nClusters), [1, 1, nClusters]); % initial covariance matrix
z_im = ones(N, nClusters);

for iter = 1 : nIter
    fprintf('Iteration %d of %d\n', iter, nIter);
    % E step
    p_xi_zim =  zeros(1, nClusters);
    for i = 1 : N
        for m = 1 : nClusters
            tmp = data(i, :) - mu_m(m, :);
            p_xi_zim(m) = (exp(-0.5 * tmp / ...
                (sigma_m(:, :, m)) * tmp')) / ...
                ((2 * pi) ^ (d / 2) * sqrt(det(sigma_m(:, :, m))));
            z_im(i,m) = (p_xi_zim(m) * pi_m(m)) / (sum(p_xi_zim .* pi_m));
        end 
    end

    % M step
    for m = 1 : nClusters
        tmp = data - mu_m(m);
        sigma_m(:, :, m) = z_im(:, m)' .* tmp' * tmp / sum(z_im(:, m));
        mu_m(m, :) = (z_im(:, m)' * data) / sum(z_im(:, m));
        pi_m(m) = sum(z_im(:, m)) / N;
    end
end

figure;
scatter(data(:, 1), data(:, 2), '.');
hold on;
scatter(mu_m(:, 1), mu_m(:, 2), 'red', 'filled');

for m = 1 : nClusters
    error_ellipse(sigma_m(:, :, m), mu_m(m, :));
end
hold off;

saveas(gcf, 'em_with_error_ellipse.png');


