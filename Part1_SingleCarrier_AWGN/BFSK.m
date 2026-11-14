N = 2e6;
bits = randi([0 1], 1, N);
Eb = 1;
s1 = sqrt(Eb)*(bits==0);           % first coordinate
s2 = sqrt(Eb)*(bits==1);           % second coordinate

EbN0_dB = 0:1:12;
BER = zeros(size(EbN0_dB));

for k = 1:length(EbN0_dB)
    EbN0  = 10^(EbN0_dB(k)/10);
    sigma = sqrt(Eb/EbN0/2);
    r1 = s1 + sigma*randn(1,N);
    r2 = s2 + sigma*randn(1,N);
    bits_hat = r2 > r1;            % pick the bigger one
    BER(k) = mean(bits_hat ~= bits);
end

th = qfunc(sqrt(10.^(EbN0_dB/10)));   % coherent BFSK: Q(sqrt(Eb/N0))
semilogy(EbN0_dB, BER, 'o-', EbN0_dB, th, '--'); grid on; ylim([1e-6 1]);
xlabel('Eb/N0 (dB)'); ylabel('BER'); legend('Simulated','Theory');
title('BFSK over AWGN');