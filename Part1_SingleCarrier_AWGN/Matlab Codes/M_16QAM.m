N = 4e6;                                    % multiple of 4
bits = randi([0 1], 1, N);
B = reshape(bits, 4, []);                   % each column = one symbol

I = (2*B(1,:) - 1) .* (3 - 2*B(2,:));       % levels -3 -1 +1 +3
Q = (2*B(3,:) - 1) .* (3 - 2*B(4,:));
tx = I + 1j*Q;

Eb = 2.5;
EbN0_dB = 0:1:14;
BER = zeros(size(EbN0_dB));

for k = 1:length(EbN0_dB)
    EbN0  = 10^(EbN0_dB(k)/10);
    sigma = sqrt(Eb/EbN0/2);
    rx = tx + sigma*(randn(size(tx)) + 1j*randn(size(tx)));

    B_hat = [ real(rx) > 0;
              abs(real(rx)) < 2;
              imag(rx) > 0;
              abs(imag(rx)) < 2 ];
    BER(k) = sum(sum(B_hat ~= B)) / N;
end

BER_theory = (3/4) * qfunc(sqrt(0.8 * 10.^(EbN0_dB/10)));
semilogy(EbN0_dB, BER, 'o-', EbN0_dB, BER_theory, '--'); grid on;
xlabel('Eb/N0 (dB)'); ylabel('BER'); legend('Simulated','Theory');
title('16QAM over AWGN');

EbN0_16qam = EbN0_dB; BER_16qam = BER; th_16qam = (3/4)*qfunc(sqrt(0.8*10.^(EbN0_dB/10)));