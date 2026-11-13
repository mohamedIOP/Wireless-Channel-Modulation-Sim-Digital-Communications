N = 2e6;                                  % total bits (even number)
bits = randi([0 1], 1, N);
b0 = bits(1:2:end);                       % even-position bits -> I
b1 = bits(2:2:end);                       % odd-position bits  -> Q
tx = (2*b0 - 1) + 1j*(2*b1 - 1);          % complex symbols

EbN0_dB = 0:1:10; % Sweep Channel from 0 to 10 dB
BER = zeros(size(EbN0_dB)); % BER That will be calulated for each EbB0

for k = 1:length(EbN0_dB)
    EbN0 = 10^(EbN0_dB(k)/10); % Convert the dB to Linear
    sigma = sqrt(1/EbN0/2);               % Eb = 1

    n  = sigma*(randn(size(tx)) + 1j*randn(size(tx))); % Get the noise factor
    rx = tx + n; % Channel + AWGN 
    % Decoding
    b0_hat = real(rx) > 0;
    b1_hat = imag(rx) > 0;
    errors = sum(b0_hat ~= b0) + sum(b1_hat ~= b1);
    BER(k) = errors / N;
end

BER_theory = qfunc(sqrt(2*10.^(EbN0_dB/10))); % Theory
semilogy(EbN0_dB, BER, 'o-', EbN0_dB, BER_theory, '--'); grid on;
xlabel('Eb/N0 (dB)'); ylabel('BER'); legend('Simulated','Theory');
title('QPSK over AWGN');