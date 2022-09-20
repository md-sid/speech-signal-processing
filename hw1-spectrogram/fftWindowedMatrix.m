function [s, f, t] = fftWindowedMatrix(windowedMatrix, blocks, params)
%[s, f, t] = fftWindowedMatrix(windowedMatrix, blocks, params) is a helper
%function for customSpectrogram
% 

s = fft(windowedMatrix);
% keep first half of the data as they are symmetric
if rem(params.nFFT, 2) == 1
    keepData = (params.nFFT + 1) / 2;
else
    keepData = params.nFFT / 2;
end
s = s(1 : keepData, :);

f = (0 : keepData - 1)*params.Fs / params.nFFT;

t = blocks / params.Fs;

end