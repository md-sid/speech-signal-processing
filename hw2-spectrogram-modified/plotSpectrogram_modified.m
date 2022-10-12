function plotSpectrogram_modified(t, f, sMag, timitData)
%plotSpectrogram_modified(t, f, sMag, nameTitle) is a helper function for
%customSpectrogram_modified
% 

imagesc(t, f, 20*log10(sMag));
axis xy;
colorbar;
colormap(jet);
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title(timitData.orthoData);
hold on;

wordTimeStamps = timitData.wordTimeStamps/16000;
phonTimeStamps = timitData.phonTimeStamps/16000;

for i = 1 : length(wordTimeStamps)
    xline(wordTimeStamps(i, 1), '-');
    xline(wordTimeStamps(i, 2), '-');
end

for i = 1 : length(phonTimeStamps)
    xline(phonTimeStamps(i, 1), 'b:');
    xline(phonTimeStamps(i, 2), 'b:');
end

end