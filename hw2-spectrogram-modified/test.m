clear; clc; close all;

timitFilename = './SA1';    % location of timit file

% define the parameters
params.nFFT = 1024;
params.window = [1, 200];
params.nOverlap = 50;
params.fsst = 0;
params.plotType = 1;
[s, f, t] = customSpectrogram_modified(timitFilename, params);


