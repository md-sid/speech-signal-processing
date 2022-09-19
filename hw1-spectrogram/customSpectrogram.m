function [s, f, t] = customSpectrogram(x, params)
%customSpectrogram is a custom spectrogram generator using a Short-Time
%Fourier Transform. 
% 
%   Usage: [s, f, t] = customSpectrogram(x, params)
%   s is the matrix of returned spectrogram
%   f is the vector of frequencies at which spectrogram is computed
%   t is the vector of times at which spectrogram is computed
%   x is the sample vector
%   params is a structure array containing the following parameters:
%       params.Fs: sampling frequency in Hz
%       params.nFFT: number of frequency points to calculate DFT
%       params.window: type of windowing (hanning, rectangular, etc.)
%       params.nOverlap: number of overlap of samples in adjoining segments
%       params.fssT: 1 to use Fourier synchrosqueezed transform instead of
%           FFT. Default value is 0
%       params.plotType: 1 to view in a tiled layout containing spectrum,
%           time domain waveform, and colorbar. 0 to view only spectrogram.
%       params.zoom: 1 to zoom into the spectrogram. Default value is 0
%       params.zoomTimeRange: start and end of time to be zoomed into. Put
%       the values in a row vector. NOTE: params.zoom must be 1
%       params.zoomFreqRange: start and end of frequency to be zoomed into.
%       Put the values in a row vector. NOTE: params.zoom must be 1
%   NOTE: params.Fs, params.nFFT, params.window, and params.nOverlap are
%   reuired. Rest of the parameters will use default values unless
%   otherwise specified.
% 

windowSize = length(params.window);
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
        s = fsst(x, params.Fs);
        modeTitle = ' with FSST';
    else
        s = fft(windowedMatrix);
        modeTitle = ' with FFT';
    end
else
    s = fft(windowedMatrix);
    modeTitle = ' with FFT';
end

% keep first half of the data as they are symmetric
if rem(params.nFFT, 2) == 1
    keepData = (params.nFFT + 1) / 2;
else
    keepData = params.nFFT / 2;
end
s = s(1 : keepData, :);

f = (0 : keepData - 1)*params.Fs / params.nFFT;

t = blocks / params.Fs;

sMag = abs(s)/max(max(abs(s)));

if isfield(params, 'plotType')
    plotFlag = 0;
    params.plotType = params.plotType || plotFlag;
    if params.plotType == 1
        time = linspace(0, length(x)/params.Fs, length(x));
        tiledPlot(x, sMag, t, time, f, modeTitle);
    else
        figure;
        plotSpectrogram(t, f, sMag, modeTitle);
    end
else
    figure;
    plotSpectrogram(t, f, sMag, modeTitle);
end

if isfield(params, 'zoom')
    zoomFlag = 0;
    params.zoom = params.zoom || zoomFlag;
    if params.zoom == 1
        if isfield(params, 'zoomTimeRange') && isfield(params, 'zoomFreqRange')
            tmp = find(time >= params.zoomTimeRange(1));
            samples = tmp(1);
            tmp = find(time <= params.zoomTimeRange(2));
            samples = samples : tmp(end);
            timeZoom = time(samples);
            xZoom = x(samples);
            
            tmp = find(t >= params.zoomTimeRange(1));
            tSamples = tmp(1);
            tmp = find(t <= params.zoomTimeRange(2));
            tSamples = tSamples : tmp(end);
            tZoom = t(tSamples);

            tmp = find(f >= params.zoomFreqRange(1));
            fSamples = tmp(1);
            tmp = find(f <= params.zoomFreqRange(2));
            fSamples = fSamples : tmp(end);
            fZoom = f(fSamples);
            sMagZoom = sMag(fSamples, tSamples);
            
            modeTitle = [modeTitle, ' and zoomed'];
            tiledPlot(xZoom, sMagZoom, tZoom, timeZoom, fZoom, modeTitle);
        else
            error('Please enter all the values for zooming!');
        end

    end

end

end