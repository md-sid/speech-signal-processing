clear; clc; close all;

Fs = 8000;  % sampling frequency in Hertz
nBits = 16; % number of bits
nChan = 1;  % 1 for mono, 2 for stereo
recDur = 4; % in seconds

recObj = audiorecorder(Fs, nBits, nChan);
disp("Read the following:");
% disp("Are your grades higher or lower than Nancy's? (sx10)");
disp("Last year's gas shortage caused steep price increases. (sx67)");
recordblocking(recObj, recDur);
disp("End of Recording!");

play(recObj);   % play the recording

y = getaudiodata(recObj);   % stores data in double
plot(y);

% audiowrite('sx10.wav', y, Fs);  % save the audio in same directory
audiowrite('sx67.wav', y, Fs);