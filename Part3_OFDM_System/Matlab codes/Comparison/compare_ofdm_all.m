%% Project Part 3 - Comparison of BPSK and 16-QAM OFDM
%  Run BPSK/ofdm_bpsk.m and QAM16/ofdm_qam16.m first to generate the .mat files.
clear; clc; close all;

this_dir  = fileparts(mfilename('fullpath'));
codes_dir = fileparts(this_dir);

bp = load(fullfile(codes_dir, 'ofdm_bpsk_results.mat'));
qa = load(fullfile(codes_dir, 'ofdm_qam16_results.mat'));

blue   = [0 0.447 0.741];
red    = [0.85 0.15 0.10];
green  = [0.10 0.60 0.20];
purple = [0.55 0.10 0.65];

%% Plot: BPSK vs. 16-QAM OFDM over Frequency-Selective Rayleigh Fading
figure('Name', 'OFDM Comparison', 'Color', 'w', 'Position', [100 100 900 600]);
semilogy(bp.SNR_dB, bp.BER(3,:), '-o',  'Color', blue,   'LineWidth', 2.2, 'MarkerSize', 7, 'MarkerFaceColor', blue); hold on;
semilogy(bp.SNR_dB, bp.BER(4,:), '-d',  'Color', green,  'LineWidth', 2.5, 'MarkerSize', 8, 'MarkerFaceColor', green);
semilogy(qa.SNR_dB, qa.BER(3,:), '--^', 'Color', purple, 'LineWidth', 2.2, 'MarkerSize', 8);
semilogy(qa.SNR_dB, qa.BER(4,:), '--s', 'Color', red,    'LineWidth', 2.5, 'MarkerSize', 8, 'MarkerFaceColor', red);

grid on; ylim([1e-5 1]); xlim([0 30]);
set(gca, 'Color', 'w', 'XColor', 'k', 'YColor', 'k', 'GridColor', 'k', ...
         'GridAlpha', 0.25, 'MinorGridAlpha', 0.12, 'FontSize', 12, 'LineWidth', 1);
xlabel('E_b/N_o (dB)', 'Color', 'k', 'FontSize', 13);
ylabel('Bit Error Rate (BER)', 'Color', 'k', 'FontSize', 13);
title('BPSK vs. 16-QAM OFDM over Frequency-Selective Rayleigh Fading', 'Color', 'k', 'FontSize', 14);
legend('BPSK - Uncoded', 'BPSK - Rate 1/5 Coded', ...
       '16-QAM - Uncoded', '16-QAM - Rate 1/5 Coded', ...
       'Location', 'southwest', 'TextColor', 'k', 'Color', 'w', 'EdgeColor', 'k', 'FontSize', 11);
