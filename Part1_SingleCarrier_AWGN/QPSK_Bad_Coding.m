N = 2e6;                                   % even number of bits
bits = randi([0 1], 1, N);
b0 = bits(1:2:end);
b1 = bits(2:2:end);

% Figure 2 (Gray): b0 -> I, b1 -> Q
tx2 = (2*b0 - 1) + 1j*(2*b1 - 1);

% Figure 3: I from b0, Q from b0 XOR b1
tx3 = (2*b0 - 1) + 1j*(2*xor(b0,b1) - 1);

EbN0_dB = 0:1:10;
BER2 = zeros(size(EbN0_dB));
BER3 = zeros(size(EbN0_dB));

for k = 1:length(EbN0_dB)
    EbN0  = 10^(EbN0_dB(k)/10);
    sigma = sqrt(1/EbN0/2);                % Eb = 1
    n = sigma*(randn(size(tx2)) + 1j*randn(size(tx2)));   % same noise for both

    % Figure 2 receiver
    rx = tx2 + n;
    b0_hat = real(rx) > 0;
    b1_hat = imag(rx) > 0;
    BER2(k) = (sum(b0_hat ~= b0) + sum(b1_hat ~= b1)) / N;

    % Figure 3 receiver
    rx = tx3 + n;
    b0_hat = real(rx) > 0;
    q_hat  = imag(rx) > 0;
    b1_hat = xor(b0_hat, q_hat);           % undo the XOR
    BER3(k) = (sum(b0_hat ~= b0) + sum(b1_hat ~= b1)) / N;
end

p = qfunc(sqrt(2*10.^(EbN0_dB/10)));
th2 = p;
th3 = 1.5*p - p.^2;

figure;
semilogy(EbN0_dB, BER2, 'bo-', EbN0_dB, BER3, 'rs-'); hold on;
semilogy(EbN0_dB, th2, 'b--', EbN0_dB, th3, 'r--');
grid on; ylim([1e-6 1]);
xlabel('Eb/N0 (dB)'); ylabel('BER');
legend('QPSK Fig.2 (Gray) sim','QPSK Fig.3 sim', ...
       'Fig.2 theory','Fig.3 theory');
title('QPSK: Gray labeling vs Figure 3 labeling');