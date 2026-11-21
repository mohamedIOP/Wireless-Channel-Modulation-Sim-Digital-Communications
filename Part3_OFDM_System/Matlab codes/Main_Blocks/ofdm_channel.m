function [rx_cp, H] = ofdm_channel(tx_cp, N_fft, L_cp, No, channel_type)
% BLOCK 4 (Channel): Rayleigh Flat Fading or Frequency-Selective Fading + AWGN
%
% Inputs:
%   tx_cp        : Transmitted time-domain OFDM symbols with CP ((N_fft+L_cp) x N_sym)
%   N_fft        : FFT size (256)
%   L_cp         : Cyclic Prefix length
%   No           : Noise PSD (complex AWGN variance = No/2 per I/Q component)
%   channel_type : 'flat' or 'freq_selective'
%
% Outputs:
%   rx_cp        : Received time-domain OFDM symbols with CP ((N_fft+L_cp) x N_sym)
%   H            : Complex frequency-domain channel gain (for equalization at Rx)
%                  - 'flat'          : (1 x N_sym)     same h for all 256 subcarriers
%                  - 'freq_selective': (N_fft x N_sym) independent H_k per subcarrier

N_sym = size(tx_cp, 2);

switch lower(channel_type)
    case 'flat'
        % Rayleigh flat fading: hr, hi ~ N(0, 1/2), constant over one OFDM symbol
        H = sqrt(1/2) * (randn(1, N_sym) + 1j*randn(1, N_sym));
        r_cp = tx_cp .* H;

    case 'freq_selective'
        % Independent Rayleigh fading per sub-channel, modeled in frequency domain
        H = sqrt(1/2) * (randn(N_fft, N_sym) + 1j*randn(N_fft, N_sym));

        % Apply H_k in frequency domain, convert back to time domain + CP
        x_no_cp = tx_cp(L_cp + 1 : end, :);
        X_freq  = fft(x_no_cp, N_fft, 1) / sqrt(N_fft);
        r_time  = ifft(H .* X_freq, N_fft, 1) * sqrt(N_fft);
        if L_cp > 0
            r_cp = [r_time(end - L_cp + 1 : end, :); r_time];
        else
            r_cp = r_time;
        end

    otherwise
        error('Unknown channel_type "%s". Use ''flat'' or ''freq_selective''.', channel_type);
end

% Add Complex AWGN: nc, ns ~ N(0, No/2)
noise = sqrt(No/2) * (randn(size(r_cp)) + 1j*randn(size(r_cp)));
rx_cp = r_cp + noise;
end