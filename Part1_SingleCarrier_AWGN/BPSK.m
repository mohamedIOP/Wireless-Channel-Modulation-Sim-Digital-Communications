N = 1e6;
% Number of Bits
bits = randi([0 1], 1, N);
% Generate N random bits of values 0 and 1
tx = 2*bits - 1; % Decode them in -1 and 1

EbN0_dB = 0:1:10;                   % sweep from 0 to 10 dB
BER = zeros(size(EbN0_dB));         
% Sweep over the values of EbN0
for k = 1:length(EbN0_dB)
    EbN0 = 10^(EbN0_dB(k)/10); % Calculate it in linear not dB
    N0 = 1/EbN0; % Get N0 
    sigma = sqrt(N0/2); % Calculate standard deviation

    rx = tx + sigma*randn(1, N); % Rx bits after adding AWGN noise
    bits_hat = rx > 0; % Decode them 
    BER(k) = mean(bits_hat ~= bits); % get the BER
end

% theory
BER_theory = qfunc(sqrt(2*10.^(EbN0_dB/10))); 

semilogy(EbN0_dB, BER, 'o-', EbN0_dB, BER_theory, '--');
grid on;
xlabel('Eb/N0 (dB)'); ylabel('BER');
legend('Simulated', 'Theory');
title('BPSK over AWGN');