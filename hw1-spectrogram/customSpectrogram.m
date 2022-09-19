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
%       params.zoom: 1 to zoom into the spectrogram. Default value is 0
%       params.zoomTimeRange: start and end of time to be zoomed into.
%           NOTE: params.zoom must be 1
%       params.zoomFreqRange: start and end of frequency to be zoomed into.
%           NOTE: params.zoom must be 1
%       params.plotType: 1 to view in a tiled layout containing spectrum,
%           time domain waveform, and colorbar. 0 to view only spectrogram.
% 
end