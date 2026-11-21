%% Project Part 3 - BPSK OFDM System Simulation
%  Chain: Data bits -> Coding -> Interleaver -> BPSK Mapper -> 256-pt IFFT
%         -> Add CP -> Channel (Flat / Freq-Selective + AWGN)
%         -> Remove CP -> 256-pt FFT -> Equalizer -> BPSK Demapper
%         -> De-interleaver -> Decoder
clear; clc; close all;
rng(1);

% Automatically add Main_Blocks folder to MATLAB path
this_dir = fileparts(mfilename('fullpath'));
addpath(fullfile(this_dir, '..', 'Main_Blocks'));

%% System Parameters
N_fft    = 256;          % 256-point IFFT/FFT
L_cp     = 32;           % Cyclic Prefix length (N_fft / 8)
N_coded  = 256;          % BPSK: 1 bit/subcarrier -> 256 coded bits per OFDM symbol
int_rows = 16;           % Interleaver size: 16 x 16 = 256 bits (1 OFDM symbol)
int_cols = 16;

Eb       = 1;            % Energy per information bit
SNR_dB   = 0:2:30;       % Eb/No in dB (matching Part 2 range)
SNR_lin  = 10.^(SNR_dB / 10);

N_batch        = 2000;   % OFDM symbols per batch
N_loop_uncoded = 2;      % 4,000 OFDM symbols -> ~1.02M bits per SNR point
N_loop_coded   = 5;      % 10,000 OFDM symbols -> 510k info bits per SNR point

% Fair energy comparison: rate 1/5 splits Eb across 5 coded bits (Ec = Eb/5).
% Set to false if comparing at equal coded-bit (channel) SNR instead of info Eb/No.
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
        N_data = floor(N_coded / 5);   % 51 data bits + 1 zero pad = 256 bits
        N_loop = N_loop_coded;
    else
        R      = 1;
        N_data = N_coded;              % 256 data bits
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
            X     = bpsk_encoder(c_int, Ec);
            tx_cp = ofdm_mod(X, N_fft, L_cp);

            % Channel (Flat or Frequency-Selective Rayleigh + AWGN)
            [rx_cp, H] = ofdm_channel(tx_cp, N_fft, L_cp, No, ch_type);

            % Receiver
            Y         = ofdm_demod(rx_cp, N_fft, L_cp);
            X_eq      = ofdm_equalizer(Y, H);
            c_int_hat = bpsk_decision(real(X_eq));
            c_hat     = block_deinterleaver(c_int_hat, int_rows, int_cols);
            b_hat     = rep_decoder(c_hat, N_coded, use_coding);

            nerr = nerr + sum(b ~= b_hat, 'all');
        end

        BER(c_idx, i) = nerr / Nbits_total;
        fprintf('  Eb/No = %2d dB | BER = %.3e\n', SNR_dB(i), BER(c_idx, i));
    end
end

%% Reference Theory (Uncoded BPSK over Rayleigh Fading - matches Part 2)
BER_th = 0.5 * (1 - sqrt(SNR_lin ./ (1 + SNR_lin)));

% Save results in "Matlab codes" folder (matching Part 2 convention)
save(fullfile(this_dir, '..', 'ofdm_bpsk_results.mat'), 'SNR_dB', 'BER', 'BER_th', 'cases');

%% ===================== PLOT =====================
blue   = [0 0.447 0.741];
red    = [0.85 0.15 0.10];
green  = [0.10 0.60 0.20];
purple = [0.55 0.10 0.65];

figure('Name', 'BPSK OFDM BER', 'Color', 'w', 'Position', [100 100 900 620]);
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
title('BPSK OFDM BER over Flat and Frequency-Selective Rayleigh Fading', 'Color', 'k', 'FontSize', 14);
legend(cases{1,3}, cases{2,3}, cases{3,3}, cases{4,3}, 'Rayleigh Uncoded (Theory)', ...
       'Location', 'southwest', 'TextColor', 'k', 'Color', 'w', 'EdgeColor', 'k', 'FontSize', 11);