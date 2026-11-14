Tb  = 1;  Eb = 1;
sps = 16;                          % samples per bit
Ts  = Tb/sps;                      % sample period
Nb  = 2e4;                         % number of bits
bits = randi([0 1], 1, Nb);

t = (0:sps-1)*Ts;                  % time within one bit
s0 = sqrt(2*Eb/Tb) * exp(-1j*pi*t/Tb);   % bit 0: -1/(2Tb)
s1 = sqrt(2*Eb/Tb) * exp(+1j*pi*t/Tb);   % bit 1: +1/(2Tb)

x = zeros(1, Nb*sps);
for k = 1:Nb
    if bits(k) == 0
        x((k-1)*sps+1 : k*sps) = s0;
    else
        x((k-1)*sps+1 : k*sps) = s1;
    end
end

Fs = 1/Ts;                         % = sps/Tb
[Pxx, f] = pwelch(x, hann(1024), 512, 2048, Fs, 'centered');

figure;
plot(f*Tb, 10*log10(Pxx)); grid on;
xlim([-4 4]);
xlabel('Frequency \times T_b'); ylabel('PSD (dB/Hz)');
title('PSD of baseband BFSK');