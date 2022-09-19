function tiledPlot(x, sMag, t, time, f, modeTitle)
%tiledPlot(x, sMag, t, time, f, modeTitle) is a helper function for
%customSpectrogram
% 

figure;
tiledlayout(3, 4);

nexttile([2 1]);
cumFreq = sum(sMag, 2);
plot(cumFreq, 'LineWidth', 1.5); view([-90 90]);
title('Spectrum');

nexttile([2 3]);
plotSpectrogram(t, f, sMag, modeTitle);

nexttile();
axis off;

nexttile([1 3]);
plot(time, x);
xlabel('Time (s)'); title('Time Domain Waveform');

end