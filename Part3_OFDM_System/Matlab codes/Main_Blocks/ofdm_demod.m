function Y = ofdm_demod(rx_cp, N_fft, L_cp)
% BLOCK 3 (Rx): Remove Cyclic Prefix + 256-point FFT
%
% Inputs:
%   rx_cp : Received time-domain OFDM symbols with CP ((N_fft + L_cp) x N_sym)
%   N_fft : FFT size (256 in Part 3)
%   L_cp  : Cyclic Prefix length in samples
%
% Output:
%   Y     : Received frequency-domain symbols (N_fft x N_sym)

assert(size(rx_cp, 1) == N_fft + L_cp, ...
    'Expected %d samples per OFDM symbol (got %d).', N_fft + L_cp, size(rx_cp, 1));

% Remove Cyclic Prefix
rx_no_cp = rx_cp(L_cp + 1 : end, :);

% Unitary FFT along columns
Y = fft(rx_no_cp, N_fft, 1) / sqrt(N_fft);
end