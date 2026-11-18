function A = analytic_signal(S)
% Analytic signal (signal + j*Hilbert transform) of every column of S.
% Used to apply a COMPLEX gain h = hr + j*hi to a real passband signal
% (in the channel block h(t) and in the Channel Inversion block).
% Each column is one symbol interval, containing an integer number of carrier
% cycles, so the result is exact for the carrier.
    Ns = size(S,1);
    F  = fft(S, [], 1);
    H  = zeros(Ns,1);
    H(1) = 1;  H(Ns/2+1) = 1;  H(2:Ns/2) = 2;   % keep DC/Nyquist, double positive freqs
    A  = ifft(F .* H, [], 1);
end
