function tiledPlot_modified(x, sMag, fs, t, f, timitData, zoomFlag)
%tiledPlot_modified(x, sMag, fs, t, f, timitData, zoomFlag) is a helper
%function for customSpectrogram_modified
% 

figure;
tiledlayout(3, 4);

P2 = abs(fft(x) / length(x));
P1 = P2(1 : length(x)/2 + 1);
P1(2 : end - 1) = 2 * P1(2 : end - 1);
ff = fs * (0 : (length(x) / 2)) / length(x);

ax1 = nexttile(1, [2 1]);
if zoomFlag == 1
    tmp = find(ff >= f(1));
    fSamples = tmp(1);
    tmp = find(ff <= f(end));
    fSamples = fSamples : tmp(end);
    ff = ff(fSamples);
    P1 = P1(fSamples);
end
plot(ff, 20 * log10(P1)); view([-90 90]);
title('Spectrum');

ax2 = nexttile(2, [2 3]);
plotSpectrogram_modified(t, f, sMag, timitData);

ax3 = nexttile(10, [1 3]);

waveform = timitData.waveform;
wordData = timitData.wordData;
wordTimeStamps = timitData.wordTimeStamps/16000;
phonData = timitData.phonData;
phonTimeStamps = timitData.phonTimeStamps/16000;

time = linspace(0, length(waveform)/16000, length(waveform));

figure(1);
plot(time, waveform);
xlabel('Time (s)'); title('Time Domain Waveform');
hold on;

for i = 1 : length(wordTimeStamps)
    xline(wordTimeStamps(i, 1), '-');
    xline(wordTimeStamps(i, 2), '-');
    center = (wordTimeStamps(i, 1) + wordTimeStamps(i, 2)) / 2;
    text(center, min(waveform) - 150, wordData(i), 'FontSize', 9);
end

for i = 1 : length(phonTimeStamps)
    xline(phonTimeStamps(i, 1), 'b:');
    xline(phonTimeStamps(i, 2), 'b:');
    center = (phonTimeStamps(i, 1) + phonTimeStamps(i, 2)) / 2;
    text(center, max(waveform) + 200, phonData(i), 'FontSize', 8);
end

linkaxes([ax2 ax3], 'xy');

end