function tx_cp = ofdm_mod(X, N_fft, L_cp)
% BLOCK 3 (Tx): 256-point IFFT + Add Cyclic Extension (Cyclic Prefix)
%
% Inputs:
%   X     : Frequency-domain modulated symbols (N_fft x N_sym)
%   N_fft : IFFT size (256 in Part 3)
%   L_cp  : Cyclic Prefix length in samples (e.g., 32 or 64)
%
% Output:
%   tx_cp : Time-domain OFDM symbols with CP ((N_fft + L_cp) x N_sym)

assert(size(X, 1) == N_fft, ...
    'Input must have %d subcarriers per OFDM symbol (got %d).', N_fft, size(X, 1));

% Unitary IFFT along columns (preserves signal & noise power)
x_time = ifft(X, N_fft, 1) * sqrt(N_fft);

% Add Cyclic Prefix (copy last L_cp samples to the beginning)
if L_cp > 0
    tx_cp = [x_time(end - L_cp + 1 : end, :); x_time];
else
    tx_cp = x_time;
end
end