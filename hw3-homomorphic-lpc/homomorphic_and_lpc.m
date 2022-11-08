clear; clc; close all;

timitData = processTimitFile('./SA1');

vowel_items = [5, 22, 30];
nfft = 1024;
P = 14;
n = 0;

for i = vowel_items
    n = n+1;
    timeStamps = timitData.phonTimeStamps(i, :);
    y = timitData.waveform(timeStamps(1) : timeStamps(2));
    subplot(3, 3, n);
    plot(y);
    title(('Vowel : ' + timitData.phonData(i)));
    
    % homomorphic signal processing
    x_hat_w = log(fft(y, nfft));
    subplot(3, 3, n+3);
    plot((0:511)*8000/512, abs(x_hat_w(1:nfft/2)), 'g');
    hold on;
    x_hat_n = ifft(x_hat_w, nfft);
    x_hat_n(P+1 : end-P) = 0;
    y_hat_w = fft(x_hat_n, nfft);
    tmp = abs(y_hat_w(1:nfft/2));
    plot((0:511)*8000/512, tmp, 'b');
    [val, loc] = findpeaks(tmp);
    plot(loc*8000/512, val, 'rx');
    title(['F1 = ', num2str(loc(1)*8000/512), '; F2 = ', num2str(loc(2)*8000/512)]);
    xlabel('Frequency (Hz)'); hold off;

    % least squares solution
    sb = y;
    sb_padded = vertcat(zeros(P, 1), sb);
    sn = zeros(length(sb), P);
    for j = 1 : length(sb)
        sn(j, :) = sb_padded(j+P-1 : -1 : j);
    end
    alpha = (sn' * sn)\(sn' * sb);
    subplot(3, 3, n+6);
    plot((0:511)*8000/512, tmp, 'b');
    hold on;
    [h, w] = freqz(nfft, alpha);
    plot(w*8000/w(end), log(abs(h)), 'r.');
    xlim tight;
    
    % auto-correlation method
    rn = zeros(P+1, 1);
    for k = 1 : P+1
        rn(k) = sum(sb(k:end) .* sb(1:end-k+1));
    end
    Rn = toeplitz(rn(1:P));
    Rb = rn(2:P+1);
    alpha = Rn\Rb;
    [h, w] = freqz(nfft, alpha);
    plot(w*8000/w(end), log(abs(h)), 'g-');
    hold off;
    legend('ceps', 'least', 'auto');
end


