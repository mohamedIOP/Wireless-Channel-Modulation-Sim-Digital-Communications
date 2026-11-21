function X_eq = ofdm_equalizer(Y, H)
% BLOCK 4 (Rx): Frequency-Domain Channel Inversion (Zero-Forcing Equalizer)
%   Assumes perfect Channel State Information (CSI) at the receiver.
%
% Inputs:
%   Y    : Received frequency-domain symbols after FFT (N_fft x N_sym)
%   H    : Complex channel gain (1 x N_sym for flat, or N_fft x N_sym for freq_selective)
%
% Output:
%   X_eq : Equalized frequency-domain symbols (N_fft x N_sym)

X_eq = Y ./ H;
end