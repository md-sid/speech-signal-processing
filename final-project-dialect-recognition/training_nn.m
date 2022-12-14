clear; clc; close all;

% load('allfeatures.mat');
load('feat_vow_phn.mat');

rng(0);
tmp = randperm(length(trn));
trn = trn(tmp, :);
tmp = randperm(length(val));
val = val(tmp, :);

% numVal = round(size(trn, 1) * 0.15);
% tmp = randperm(size(trn, 1));
% trn = trn(tmp, :);
% val = trn(tmp(1 : numVal), :);
% trn(tmp(1 : numVal), :) = [];

trn = renamevars(array2table(trn), 'trn39', 'label');
trn = convertvars(trn, 'label', 'categorical');
% trn(trn.label == '0', end) = {'new england'};
% trn(trn.label == '1', end) = {'northern'};

val = renamevars(array2table(val), 'val39', 'label');
val = convertvars(val, 'label', 'categorical');

tst = renamevars(array2table(tst), 'tst39', 'label');
tst = convertvars(tst, 'label', 'categorical');

numFeatures = 38;
numClasses = 8;

layers = [featureInputLayer(numFeatures, 'Normalization', 'zscore')
    fullyConnectedLayer(50)
    batchNormalizationLayer
    reluLayer
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

miniBatchSize = 16;

options = trainingOptions('sgdm', ...
    'MiniBatchSize',miniBatchSize, ...
    'Shuffle','every-epoch', ...
    'InitialLearnRate', 1e-3, ...
    'ValidationData',val, ...
    'Verbose',true);
%     'Plots','training-progress', ...

[net, history] = trainNetwork(trn, 'label', layers, options);

%% test the network

pred = classify(net, tst(:, 1 : end - 1), 'MiniBatchSize', miniBatchSize);

yTest = tst.label;
acc = sum(pred == yTest) / numel(yTest)

figure; confusionchart(yTest, pred)


