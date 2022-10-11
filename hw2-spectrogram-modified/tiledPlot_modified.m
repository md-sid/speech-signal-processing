function tiledPlot(x, sMag, fs, t, time, f, modeTitle, zoomFlag)
%tiledPlot(x, sMag, fs, t, time, f, modeTitle, zoomFlag) is a helper
%function for customSpectrogram
% 

figure;
tiledlayout(3, 4);

P2 = abs(fft(x) / length(x));
P1 = P2(1 : length(x)/2 + 1);
P1(2 : end - 1) = 2 * P1(2 : end - 1);
ff = fs * (0 : (length(x) / 2)) / length(x);

nexttile(1, [2 1]);
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

nexttile(2, [2 3]);
plotSpectrogram(t, f, sMag, modeTitle);

nexttile(10, [1 3]);
plot(time, x);
xlabel('Time (s)'); title('Time Domain Waveform');

end