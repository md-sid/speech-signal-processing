function plotSpectrogram(t, f, sMag, modeTitle)
%plotSpectrogram(t, f, logS) is a helper function for customSpectrogram
% 

imagesc(t, f, 20*log10(sMag));
axis xy;
colorbar;
colormap(jet);
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title(['Spectrogram', modeTitle]);

end