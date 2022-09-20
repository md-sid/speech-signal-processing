% This script shows example parameters to use customSpectrogram
% 

clear; clc; close all;
[x, fs] = audioread("sx67.wav");

%% get the values and plot only spectrogram
params.Fs = fs;
params.nFFT = 1024;
% need to specify window type
% 0 for hanning, 1 for hamming, 2 for rectwin, 3 for kaiser, 4 for chebwin
params.window = [1, 10];
params.nOverlap = 2;
params.fsst = 0;    % use 1 to use FSST
params.plotType = 1;    % if 0 or not used then plots only spectrogram
params.zoom = 1;    % 1 to zoom into spectrogram with given boundaries
params.zoomTimeRange = [1.5 2];
params.zoomFreqRange = [500 1500];

[s, f, t] = customSpectrogram(x, params);