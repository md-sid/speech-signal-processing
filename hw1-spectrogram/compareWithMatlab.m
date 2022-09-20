clear; clc; close all;
[x, fs] = audioread("sx67.wav");

params.Fs = fs;
params.nFFT = 1024;
% need to specify window type
% 0 for hanning, 1 for hamming, 2 for rectwin, 3 for kaiser, 4 for chebwin
params.window = [1, 200];
params.nOverlap = 50;
[s, f, t] = customSpectrogram(x, params);
title('Calculated Spectrogram');

% matlab spectrogram
figure; spectrogram(x, hamming(200), 50, fs, 'yaxis');
title('Spectrogram using Matlab function');

% power spectrum
P2 = abs(fft(x) / length(x));
P1 = P2(1 : length(x)/2 + 1);
P1(2 : end - 1) = 2 * P1(2 : end - 1);
ff = fs * (0 : (length(x) / 2)) / length(x);
figure; plot(ff, 20 * log10(P1));
title('Calculated Power Spectrum');

% matlab power spectrum
[p, fp] = pspectrum(x, fs);
figure; plot(fp, pow2db(p));
grid on;
xlabel('Frequency (Hz)');
ylabel('Power Spectrum (dB)');
title('Matlab Power Spectrum');

% matlab Wigner-Ville distribution
% runs out of memory! so could not do this
