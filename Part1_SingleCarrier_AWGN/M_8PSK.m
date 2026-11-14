N = 3e6;                                   % multiple of 3
bits = randi([0 1], 1, N);
B = reshape(bits, 3, []).';                % each row = one symbol's 3 bits
dec = B * [4; 2; 1];                       % label as number 0..7

% constellation, indexed by label decimal + 1
labels_dec = [0 1 3 2 6 7 5 4];            % 000 001 011 010 110 111 101 100
const = zeros(1, 8);
const(labels_dec + 1) = sqrt(3) * exp(1j*(0:7)*pi/4);

tx = const(dec + 1).';                     % column of complex symbols

EbN0_dB = 0:1:12;
BER = zeros(size(EbN0_dB));

for k = 1:length(EbN0_dB)
    EbN0 = 10^(EbN0_dB(k)/10);
    sigma = sqrt(1/EbN0/2);
    rx = tx + sigma*(randn(size(tx)) + 1j*randn(size(tx)));

    [~, idx] = min(abs(rx - const), [], 2);   % nearest point (N/3 x 8 distances)
    dec_hat = idx - 1;                        % back to label decimal
    B_hat = [bitget(dec_hat,3), bitget(dec_hat,2), bitget(dec_hat,1)];
    BER(k) = sum(sum(B_hat ~= B)) / N;
end

BER_theory = (2/3) * qfunc(sqrt(6*10.^(EbN0_dB/10)) * sin(pi/8));
semilogy(EbN0_dB, BER, 'o-', EbN0_dB, BER_theory, '--'); grid on;
xlabel('Eb/N0 (dB)'); ylabel('BER'); legend('Simulated','Theory');
title('8PSK over AWGN');

EbN0_8psk = EbN0_dB; BER_8psk = BER; th_8psk = (2/3)*qfunc(sqrt(6*10.^(EbN0_dB/10))*sin(pi/8));