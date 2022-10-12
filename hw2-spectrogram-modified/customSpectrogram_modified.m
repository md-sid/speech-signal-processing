function [s, f, t] = customSpectrogram_modified(timitFilename, params)
%customSpectrogram_modified is a custom spectrogram generator using a FFT or FSST.
% 
%   Usage: [s, f, t] = customSpectrogram(x, params)
%   s is the matrix of returned spectrogram
%   f is the vector of frequencies at which spectrogram is computed
%   t is the vector of times at which spectrogram is computed
%   timitFilename is the filename from TIMIT dataset with location
%   params is a structure array containing the following parameters:
%       params.nFFT: number of frequency points to calculate DFT
%       params.window: is a 1x2 row vector where first value specifies the
%           type of window and the second value gives the window length.
%           0 for hanning, 1 for hamming, 2 for rectwin, 3 for
%           kaiser, 4 for chebwin
%       params.nOverlap: number of overlap of samples in adjoining segments
%       params.fsst: 1 to use Fourier synchrosqueezed transform instead of
%           FFT. Default value is 0
%       params.plotType: 1 to view in a tiled layout containing spectrum,
%           time domain waveform, and colorbar. 0 to view only spectrogram.
%   NOTE: params.nFFT, params.window, and params.nOverlap are
%   reuired. Rest of the parameters will use default values unless
%   otherwise specified.
% 

timitData = processTimitFile(timitFilename);
x = timitData.waveform; % audio data
params.Fs = 16000;  % 16000 sampling rate for TIMIT dataset

windowSize = params.window(2);
if params.window(1) == 0
    params.window = hanning(params.window(2));
elseif params.window(1) == 1
    params.window = hamming(params.window(2));
elseif params.window(1) == 2
    params.window = rectwin(params.window(2));
elseif params.window(1) == 3
    params.window = kaiser(params.window(2));
elseif params.window(1) == 4
    params.window = chebwin(params.window(2));
else
    error('Please specify window properly!');
end

step = windowSize - params.nOverlap;
blocks = 1 : step : length(x) - windowSize;

windowedMatrix = zeros(params.nFFT, length(blocks));
for i = 1 : length(blocks)
    windowedMatrix(1 : windowSize, i) = x(blocks(i) : blocks(i) + windowSize - 1) .* params.window;
end

% FFT or FSST
if isfield(params, 'fsst')
    fsstFlag = 0;
    params.fsst = params.fsst || fsstFlag;
    if params.fsst == 1
        [s, f, t] = fsst(x, params.Fs);
    else
        [s, f, t] = fftWindowedMatrix(windowedMatrix, blocks, params);
    end
else
    [s, f, t] = fftWindowedMatrix(windowedMatrix, blocks, params);
end

sMag = abs(s)/max(max(abs(s)));     % normalize

if isfield(params, 'plotType')
    plotFlag = 0;
    params.plotType = params.plotType || plotFlag;
    if params.plotType == 1
        time = linspace(0, length(x)/params.Fs, length(x));
        tiledPlot_modified(x, sMag, params.Fs, t, f, timitData, 0);
    else
        figure;
        plotSpectrogram_modified(t, f, sMag, timitData);
    end
else
    figure;
    plotSpectrogram_modified(t, f, sMag, timitData);
end

end