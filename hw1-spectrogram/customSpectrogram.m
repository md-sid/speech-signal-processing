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
%       params.window: is a 1x2 row vector where first value specifies the
%           type of window and the second value gives the window length.
%           0 for hanning, 1 for hamming, 2 for rectwin, 3 for
%           kaiser, 4 for chebwin
%       params.nOverlap: number of overlap of samples in adjoining segments
%       params.fsst: 1 to use Fourier synchrosqueezed transform instead of
%           FFT. Default value is 0
%       params.plotType: 1 to view in a tiled layout containing spectrum,
%           time domain waveform, and colorbar. 0 to view only spectrogram.
%       params.zoom: 1 to zoom into the spectrogram. Default value is 0
%       params.zoomTimeRange: start and end of time to be zoomed into. Put
%       the values in a 1x2 row vector. NOTE: params.zoom must be 1
%       params.zoomFreqRange: start and end of frequency to be zoomed into.
%       Put the values in a 1x2 row vector. NOTE: params.zoom must be 1
%   NOTE: params.Fs, params.nFFT, params.window, and params.nOverlap are
%   reuired. Rest of the parameters will use default values unless
%   otherwise specified.
% 

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
        modeTitle = ' with FSST';
    else
        [s, f, t] = fftWindowedMatrix(windowedMatrix, blocks, params);
        modeTitle = ' with FFT';
    end
else
    [s, f, t] = fftWindowedMatrix(windowedMatrix, blocks, params);
    modeTitle = ' with FFT';
end

sMag = abs(s)/max(max(abs(s)));     % normalize

if isfield(params, 'plotType')
    plotFlag = 0;
    params.plotType = params.plotType || plotFlag;
    if params.plotType == 1
        time = linspace(0, length(x)/params.Fs, length(x));
        tiledPlot(x, sMag, params.Fs, t, time, f, modeTitle, 0);
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
            tiledPlot(xZoom, sMagZoom, params.Fs, tZoom, timeZoom, fZoom, modeTitle, 1);
        else
            error('Please enter all the values for zooming!');
        end

    end

end

end