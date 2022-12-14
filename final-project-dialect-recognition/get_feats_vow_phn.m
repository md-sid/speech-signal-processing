clc; clear; close all;

wavFiles = [dir('./data/DR1/*.WAV*');   % 380
            dir('./data/DR2/*.WAV*');   % 760   1140
            dir('./data/DR3/*.WAV*');   % 760   1900
            dir('./data/DR4/*.WAV*');   % 680   2580
            dir('./data/DR5/*.WAV*');   % 700   3280
            dir('./data/DR6/*.WAV*');   % 350   3630
            dir('./data/DR7/*.WAV*');   % 770   4400
            dir('./data/DR8/*.WAV*')];  % 220   4620
        
phnFiles = [dir('./data/DR1/*.PHN*');   % 380
            dir('./data/DR2/*.PHN*');   % 760   1140
            dir('./data/DR3/*.PHN*');   % 760   1900
            dir('./data/DR4/*.PHN*');   % 680   2580
            dir('./data/DR5/*.PHN*');   % 700   3280
            dir('./data/DR6/*.PHN*');   % 350   3630
            dir('./data/DR7/*.PHN*');   % 770   4400
            dir('./data/DR8/*.PHN*')];  % 220   4620

vowel_phonemes = ["iy", "ih", "eh", "ey", "ae", "aa", "aw", "ay", "ah", ...
    "ao", "oy", "ow", "uh", "uw", "ux", "er", "ax", "ix", "axr", "ax-h"];
allFeat = cell(length(wavFiles), 1);

tic

parfor i = 1 : length(wavFiles)
    fprintf('%d of %d\n', i, length(wavFiles));
    
    classLabel = str2double(wavFiles(i).folder(end));
    wavFileName = [wavFiles(i).folder, '/', wavFiles(i).name];
    fid = fopen(wavFileName);
    fseek(fid,1024, -1); % skip header
    y = fread(fid,inf,'int16'); % read speech data
    fclose(fid);
    
    phnFileName = [phnFiles(i).folder, '/', phnFiles(i).name];
    phonID = fopen(phnFileName, 'r');
    tmpLine = fgetl(phonID);    % gives cell array
    n = 0;
    count = 0;
    phonTimeStamps = zeros;
    tmpFeat = [];

    while ischar(tmpLine)
        phonLine = split(tmpLine);
        
        if find(phonLine{3} == vowel_phonemes)
            count = count + 1;
            phonTimeStamps(count, 1) = str2double(phonLine{1});
            phonTimeStamps(count, 2) = str2double(phonLine{2});
            tmpY = y(str2double(phonLine{1}) : str2double(phonLine{2}));
            
            autoenc = trainAutoencoder(tmpY',25, ...
                'L2WeightRegularization',0.01, ...
                'SparsityRegularization',4, ...
                'SparsityProportion',0.10, ...
                'ShowProgressWindow',false);

            meanCoeffs = mean(mfcc(tmpY, 16000, 'LogEnergy', 'ignore', ...
                'Window', hamming(75), 'OverlapLength', 50), 1);
            tmpFeat(count, :) = [autoenc.EncoderWeights', ...
                meanCoeffs, classLabel];
            
        end
        
        tmpLine = fgetl(phonID);
        n = n + 1;
    end
    fclose(phonID);
    
    allFeat{i} = tmpFeat;
    
end

toc

%% separate data for training and testing
rng(0);
tmp1 = randperm(380); 
nTrn =  round(length(tmp1)*0.7);    trn = allFeat(tmp1(1:nTrn));
nVal = round(length(tmp1)*0.15);    val = allFeat(tmp1(nTrn+1:nTrn+nVal));
tst = allFeat(tmp1(nTrn+nVal+1:end));

tmp2 = 380 + randperm(760);
nTrn =  round(length(tmp2)*0.7);    trn = [trn; allFeat(tmp2(1:nTrn))];
nVal = round(length(tmp2)*0.15);    val = [val; allFeat(tmp2(nTrn+1:nTrn+nVal))];
tst = [tst; allFeat(tmp2(nTrn+nVal+1:end))];

tmp3 = 1140 + randperm(760);
nTrn =  round(length(tmp3)*0.7);    trn = [trn; allFeat(tmp3(1:nTrn))];
nVal = round(length(tmp3)*0.15);    val = [val; allFeat(tmp3(nTrn+1:nTrn+nVal))];
tst = [tst; allFeat(tmp3(nTrn+nVal+1:end))];

tmp4 = 1900 + randperm(680);
nTrn =  round(length(tmp4)*0.7);    trn = [trn; allFeat(tmp4(1:nTrn))];
nVal = round(length(tmp4)*0.15);    val = [val; allFeat(tmp4(nTrn+1:nTrn+nVal))];
tst = [tst; allFeat(tmp4(nTrn+nVal+1:end))];

tmp5 = 2580 + randperm(700);
nTrn =  round(length(tmp5)*0.7);    trn = [trn; allFeat(tmp5(1:nTrn))];
nVal = round(length(tmp5)*0.15);    val = [val; allFeat(tmp5(nTrn+1:nTrn+nVal))];
tst = [tst; allFeat(tmp5(nTrn+nVal+1:end))];

tmp6 = 3280 + randperm(350);
nTrn =  round(length(tmp6)*0.7);    trn = [trn; allFeat(tmp6(1:nTrn))];
nVal = round(length(tmp6)*0.15);    val = [val; allFeat(tmp6(nTrn+1:nTrn+nVal))];
tst = [tst; allFeat(tmp6(nTrn+nVal+1:end))];

tmp7 = 3630 + randperm(770);
nTrn =  round(length(tmp7)*0.7);    trn = [trn; allFeat(tmp7(1:nTrn))];
nVal = round(length(tmp7)*0.15);    val = [val; allFeat(tmp7(nTrn+1:nTrn+nVal))];
tst = [tst; allFeat(tmp7(nTrn+nVal+1:end))];

tmp8 = 4400 + randperm(220);
nTrn =  round(length(tmp8)*0.7);    trn = [trn; allFeat(tmp8(1:nTrn))];
nVal = round(length(tmp8)*0.15);    val = [val; allFeat(tmp8(nTrn+1:nTrn+nVal))];
tst = [tst; allFeat(tmp8(nTrn+nVal+1:end))];

trn = cell2mat(trn);
tst = cell2mat(tst);
val = cell2mat(val);

save('feat_vow_phn.mat', 'trn', 'val', 'tst', '-v7.3');
fprintf('feat_vow_phn.mat is saved\nProgram Complete\n');