%% Project Part 3 - Combined Comparison of All 8 OFDM Cases (BPSK & 16-QAM)
%  Run BPSK/ofdm_bpsk.m and QAM16/ofdm_qam16.m first to generate the .mat files.
clear; clc; close all;

this_dir  = fileparts(mfilename('fullpath'));
codes_dir = fileparts(this_dir);

bp = load(fullfile(codes_dir, 'ofdm_bpsk_results.mat'));
qa = load(fullfile(codes_dir, 'ofdm_qam16_results.mat'));

blue   = [0 0.447 0.741];
red    = [0.85 0.15 0.10];
purple = [0.55 0.10 0.65];
green  = [0.10 0.60 0.20];

%% Plot: All 8 Cases Overlaid (Solid = BPSK, Dashed = 16-QAM)
figure('Name', 'OFDM Combined Comparison (All 8 Cases)', 'Color', 'w', 'Position', [100 100 940 620]);

% BPSK (4 cases) - solid lines, filled markers
semilogy(bp.SNR_dB, bp.BER(1,:), '-o', 'Color', blue,   'LineWidth', 2.0, 'MarkerSize', 6.5, 'MarkerFaceColor', blue); hold on;
semilogy(bp.SNR_dB, bp.BER(2,:), '-s', 'Color', red,    'LineWidth', 2.0, 'MarkerSize', 6.5, 'MarkerFaceColor', red);
semilogy(bp.SNR_dB, bp.BER(3,:), '-^', 'Color', purple, 'LineWidth', 2.0, 'MarkerSize', 7.0, 'MarkerFaceColor', purple);
semilogy(bp.SNR_dB, bp.BER(4,:), '-d', 'Color', green,  'LineWidth', 2.4, 'MarkerSize', 7.0, 'MarkerFaceColor', green);

% 16-QAM (4 cases) - dashed lines, hollow (white-filled) markers
semilogy(qa.SNR_dB, qa.BER(1,:), '--o', 'Color', blue,   'LineWidth', 2.0, 'MarkerSize', 6.5, 'MarkerFaceColor', 'w');
semilogy(qa.SNR_dB, qa.BER(2,:), '--s', 'Color', red,    'LineWidth', 2.0, 'MarkerSize', 6.5, 'MarkerFaceColor', 'w');
semilogy(qa.SNR_dB, qa.BER(3,:), '--^', 'Color', purple, 'LineWidth', 2.0, 'MarkerSize', 7.0, 'MarkerFaceColor', 'w');
semilogy(qa.SNR_dB, qa.BER(4,:), '--d', 'Color', green,  'LineWidth', 2.4, 'MarkerSize', 7.0, 'MarkerFaceColor', 'w');

grid on; ylim([1e-5 1]); xlim([0 30]);
set(gca, 'Color', 'w', 'XColor', 'k', 'YColor', 'k', 'GridColor', 'k', ...
         'GridAlpha', 0.25, 'MinorGridAlpha', 0.12, 'FontSize', 12, 'LineWidth', 1);
xlabel('E_b/N_o (dB)', 'Color', 'k', 'FontSize', 13);
ylabel('Bit Error Rate (BER)', 'Color', 'k', 'FontSize', 13);
title('All 8 Cases: BPSK vs. 16-QAM OFDM over Flat & Freq-Selective Fading', 'Color', 'k', 'FontSize', 13.5);
legend('BPSK: Flat - No Coding',        'BPSK: Flat - Rate 1/5 Coding', ...
       'BPSK: Freq-Sel. - No Coding',   'BPSK: Freq-Sel. - Rate 1/5 Coding', ...
       '16-QAM: Flat - No Coding',      '16-QAM: Flat - Rate 1/5 Coding', ...
       '16-QAM: Freq-Sel. - No Coding', '16-QAM: Freq-Sel. - Rate 1/5 Coding', ...
       'Location', 'southwest', 'TextColor', 'k', 'Color', 'w', 'EdgeColor', 'k', 'FontSize', 9.5);
