clear; clc; close all;

wavFiles = [dir('./data/DR1/*.WAV*');   % 380
            dir('./data/DR2/*.WAV*');   % 760   1140
            dir('./data/DR3/*.WAV*');   % 760   1900
            dir('./data/DR4/*.WAV*');   % 680   2580
            dir('./data/DR5/*.WAV*');   % 700   3280
            dir('./data/DR6/*.WAV*');   % 350   3630
            dir('./data/DR7/*.WAV*');   % 770   4400
            dir('./data/DR8/*.WAV*')];  % 220   4620

allFeat = zeros(length(wavFiles), 38);  % total number of samples

parfor i = 1 : length(wavFiles)
    fprintf('%d of %d\n', i, length(wavFiles));
    [y, fs] = audioread([wavFiles(i).folder, '/', wavFiles(i).name]);
    
    autoenc = trainAutoencoder(y',25, ...
            'L2WeightRegularization',0.01, ...
            'SparsityRegularization',4, ...
            'SparsityProportion',0.10, ...
            'ShowProgressWindow',false);
    
    meanCoeffs = mean(mfcc(y, fs, 'LogEnergy', 'ignore'));
    allFeat(i, :) = [autoenc.EncoderWeights', meanCoeffs];
end
allFeat(1 : 380, 39) = 1;
allFeat(381 : 1140, 39) = 2;
allFeat(1141 : 1900, 39) = 3;
allFeat(1901 : 2580, 39) = 4;
allFeat(2581 : 3280, 39) = 5;
allFeat(3281 : 3630, 39) = 6;
allFeat(3631 : 4400, 39) = 7;
allFeat(4401 : 4620, 39) = 8;

%% separate data for training and testing
rng(0);
tmp1 = randperm(380); 
nTrn =  round(length(tmp1)*0.7);    trn = allFeat(tmp1(1:nTrn), :);
nVal = round(length(tmp1)*0.15);    val = allFeat(tmp1(nTrn+1:nTrn+nVal), :);
tst = allFeat(tmp1(nTrn+nVal+1:end), :);

tmp2 = 380 + randperm(760);
nTrn =  round(length(tmp2)*0.7);    trn = [trn; allFeat(tmp2(1:nTrn), :)];
nVal = round(length(tmp2)*0.15);    val = [val; allFeat(tmp2(nTrn+1:nTrn+nVal), :)];
tst = [tst; allFeat(tmp2(nTrn+nVal+1:end), :)];

tmp3 = 1140 + randperm(760);
nTrn =  round(length(tmp3)*0.7);    trn = [trn; allFeat(tmp3(1:nTrn), :)];
nVal = round(length(tmp3)*0.15);    val = [val; allFeat(tmp3(nTrn+1:nTrn+nVal), :)];
tst = [tst; allFeat(tmp3(nTrn+nVal+1:end), :)];

tmp4 = 1900 + randperm(680);
nTrn =  round(length(tmp4)*0.7);    trn = [trn; allFeat(tmp4(1:nTrn), :)];
nVal = round(length(tmp4)*0.15);    val = [val; allFeat(tmp4(nTrn+1:nTrn+nVal), :)];
tst = [tst; allFeat(tmp4(nTrn+nVal+1:end), :)];

tmp5 = 2580 + randperm(700);
nTrn =  round(length(tmp5)*0.7);    trn = [trn; allFeat(tmp5(1:nTrn), :)];
nVal = round(length(tmp5)*0.15);    val = [val; allFeat(tmp5(nTrn+1:nTrn+nVal), :)];
tst = [tst; allFeat(tmp5(nTrn+nVal+1:end), :)];

tmp6 = 3280 + randperm(350);
nTrn =  round(length(tmp6)*0.7);    trn = [trn; allFeat(tmp6(1:nTrn), :)];
nVal = round(length(tmp6)*0.15);    val = [val; allFeat(tmp6(nTrn+1:nTrn+nVal), :)];
tst = [tst; allFeat(tmp6(nTrn+nVal+1:end), :)];

tmp7 = 3630 + randperm(770);
nTrn =  round(length(tmp7)*0.7);    trn = [trn; allFeat(tmp7(1:nTrn), :)];
nVal = round(length(tmp7)*0.15);    val = [val; allFeat(tmp7(nTrn+1:nTrn+nVal), :)];
tst = [tst; allFeat(tmp7(nTrn+nVal+1:end), :)];

tmp8 = 4400 + randperm(220);
nTrn =  round(length(tmp8)*0.7);    trn = [trn; allFeat(tmp8(1:nTrn), :)];
nVal = round(length(tmp8)*0.15);    val = [val; allFeat(tmp8(nTrn+1:nTrn+nVal), :)];
tst = [tst; allFeat(tmp8(nTrn+nVal+1:end), :)];

% tmp = randperm(size(trn, 1));
% trn = trn(tmp, :);

save('allfeatures.mat', 'trn', 'val', 'tst', '-v7.3');
