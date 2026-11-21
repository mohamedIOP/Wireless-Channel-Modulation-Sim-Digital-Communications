%% Project Part 3 - 16-QAM OFDM System Simulation
%  Chain: Data bits -> Coding -> Interleaver (32x32) -> 16-QAM Mapper -> 256-pt IFFT
%         -> Add CP -> Channel (Flat / Freq-Selective + AWGN)
%         -> Remove CP -> 256-pt FFT -> Equalizer -> 16-QAM Demapper
%         -> De-interleaver (32x32) -> Decoder
clear; clc; close all;
rng(2);

% Automatically add Main_Blocks folder to MATLAB path
this_dir = fileparts(mfilename('fullpath'));
addpath(fullfile(this_dir, '..', 'Main_Blocks'));

%% System Parameters
N_fft    = 256;          % 256-point IFFT/FFT
L_cp     = 32;           % Cyclic Prefix length (N_fft / 8)
N_coded  = 1024;         % 16-QAM: 4 bits/subcarrier -> 1024 coded bits per OFDM symbol
int_rows = 32;           % Interleaver size: 32 x 32 = 1024 bits (from handout)
int_cols = 32;

Eb       = 1;            % Energy per information bit
SNR_dB   = 0:2:30;       % Eb/No in dB (matching Part 2 range)
SNR_lin  = 10.^(SNR_dB / 10);

N_batch        = 2000;   % OFDM symbols per batch
N_loop_uncoded = 3;      % 6,000 OFDM symbols -> ~6.1M bits per SNR point
N_loop_coded   = 4;      % 8,000 OFDM symbols -> ~1.6M info bits per SNR point

% Fair energy comparison: rate 1/5 splits Eb across 5 coded bits (Ec = Eb/5).
fair_Eb_scaling = true;

%% Define the 4 Required Scenarios
cases = {
    'flat',           false, 'Flat Fading - No Coding';
    'flat',           true,  'Flat Fading - Rate 1/5 Coding';
    'freq_selective', false, 'Freq-Selective - No Coding';
    'freq_selective', true,  'Freq-Selective - Rate 1/5 Coding'
};

BER = zeros(4, numel(SNR_dB));

%% Run Simulation for All 4 Cases
for c_idx = 1:4
    ch_type    = cases{c_idx, 1};
    use_coding = cases{c_idx, 2};
    label      = cases{c_idx, 3};

    if use_coding
        R      = 1/5;
        N_data = floor(N_coded / 5);   % 204 data bits + 4 zero pads = 1024 bits
        N_loop = N_loop_coded;
    else
        R      = 1;
        N_data = N_coded;              % 1024 data bits
        N_loop = N_loop_uncoded;
    end

    Ec = fair_Eb_scaling * (R * Eb) + (~fair_Eb_scaling) * Eb;
    Nbits_total = N_data * N_batch * N_loop;

    fprintf('\n--- Running: %s ---\n', label);
    for i = 1:numel(SNR_dB)
        No   = Eb / SNR_lin(i);
        nerr = 0;

        for q = 1:N_loop
            % Transmitter
            b     = randi([0 1], N_data, N_batch);
            c     = rep_encoder(b, N_coded, use_coding);
            c_int = block_interleaver(c, int_rows, int_cols);
            X     = reshape(qam16_mapper(c_int, Ec), N_fft, N_batch);
            tx_cp = ofdm_mod(X, N_fft, L_cp);

            % Channel (Flat or Frequency-Selective Rayleigh + AWGN)
            [rx_cp, H] = ofdm_channel(tx_cp, N_fft, L_cp, No, ch_type);

            % Receiver
            Y         = ofdm_demod(rx_cp, N_fft, L_cp);
            X_eq      = ofdm_equalizer(Y, H);
            b_rx_vec  = qam16_decision(real(X_eq(:).'), imag(X_eq(:).'), Ec);
            c_int_hat = reshape(b_rx_vec, N_coded, N_batch);
            c_hat     = block_deinterleaver(c_int_hat, int_rows, int_cols);
            b_hat     = rep_decoder(c_hat, N_coded, use_coding);

            nerr = nerr + sum(b ~= b_hat, 'all');
        end

        BER(c_idx, i) = nerr / Nbits_total;
        fprintf('  Eb/No = %2d dB | BER = %.3e\n', SNR_dB(i), BER(c_idx, i));
    end
end

%% Reference Theory (Uncoded Gray 16-QAM over Rayleigh Fading - matches Part 2)
BER_th = (3/4) * 0.5 .* (1 - sqrt(0.4 * SNR_lin ./ (1 + 0.4 * SNR_lin)));

% Save results in "Matlab codes" folder (matching Part 2 convention)
save(fullfile(this_dir, '..', 'ofdm_qam16_results.mat'), 'SNR_dB', 'BER', 'BER_th', 'cases');

%% ===================== PLOT =====================
blue   = [0 0.447 0.741];
red    = [0.85 0.15 0.10];
green  = [0.10 0.60 0.20];
purple = [0.55 0.10 0.65];

figure('Name', '16-QAM OFDM BER', 'Color', 'w', 'Position', [100 100 900 620]);
semilogy(SNR_dB, BER(1,:), '-o', 'Color', blue,   'LineWidth', 2.2, 'MarkerSize', 7, 'MarkerFaceColor', blue); hold on;
semilogy(SNR_dB, BER(2,:), '-s', 'Color', red,    'LineWidth', 2.2, 'MarkerSize', 8, 'MarkerFaceColor', red);
semilogy(SNR_dB, BER(3,:), '-^', 'Color', purple, 'LineWidth', 2.2, 'MarkerSize', 8);
semilogy(SNR_dB, BER(4,:), '-d', 'Color', green,  'LineWidth', 2.5, 'MarkerSize', 8, 'MarkerFaceColor', green);
semilogy(SNR_dB, BER_th,   'k--', 'LineWidth', 1.6);

grid on; ylim([1e-5 1]); xlim([min(SNR_dB) max(SNR_dB)]);
set(gca, 'Color', 'w', 'XColor', 'k', 'YColor', 'k', 'GridColor', 'k', ...
         'GridAlpha', 0.25, 'MinorGridAlpha', 0.12, 'FontSize', 12, 'LineWidth', 1);
xlabel('E_b/N_o (dB)', 'Color', 'k', 'FontSize', 13);
ylabel('Bit Error Rate (BER)', 'Color', 'k', 'FontSize', 13);
title('16-QAM OFDM BER over Flat and Frequency-Selective Rayleigh Fading', 'Color', 'k', 'FontSize', 14);
legend(cases{1,3}, cases{2,3}, cases{3,3}, cases{4,3}, 'Rayleigh Uncoded (Theory, approx.)', ...
       'Location', 'southwest', 'TextColor', 'k', 'Color', 'w', 'EdgeColor', 'k', 'FontSize', 11);