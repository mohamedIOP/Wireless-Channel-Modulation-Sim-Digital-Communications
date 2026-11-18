%% Project Part 2 - Block 4: comparison of BPSK, QPSK and 16-QAM
%  Run bpsk_rayleigh.m, qpsk_rayleigh.m and qam16_rayleigh.m first
%  (each one saves its results to a .mat file).
clear; clc; close all;

bp = load('bpsk_results.mat');
qp = load('qpsk_results.mat');
qa = load('qam16_results.mat');

%% ===================== PLOTS =====================
blue = [0 0.447 0.741];  red = [0.85 0.15 0.10];  purple = [0.55 0.10 0.65];

figure('Name','BER comparison','Color','w','Position',[100 100 900 620]);
semilogy(bp.SNR_dB, bp.BER, '-o', 'Color', blue, 'LineWidth', 2.5, 'MarkerSize', 7,  'MarkerFaceColor', blue); hold on;
semilogy(qp.SNR_dB, qp.BER, '-s', 'Color', red,  'LineWidth', 2.5, 'MarkerSize', 12);
semilogy(qa.SNR_dB, qa.BER, '-^', 'Color', purple, 'LineWidth', 2.5, 'MarkerSize', 8, 'MarkerFaceColor', purple);
semilogy(bp.SNR_dB, bp.BER_th, '--', 'Color', blue,   'LineWidth', 1.5);
semilogy(qp.SNR_dB, qp.BER_th, ':',  'Color', red,    'LineWidth', 2.5);
semilogy(qa.SNR_dB, qa.BER_th, '--', 'Color', purple, 'LineWidth', 1.5);
grid on; ylim([1e-5 1]); xlim([min(bp.SNR_dB) max(bp.SNR_dB)]);
set(gca, 'Color','w', 'XColor','k', 'YColor','k', 'GridColor','k', ...
         'GridAlpha',0.25, 'MinorGridAlpha',0.12, 'FontSize',12, 'LineWidth',1);
xlabel('E_b/N_o (dB)', 'Color','k', 'FontSize',13);
ylabel('Bit Error Rate (BER)', 'Color','k', 'FontSize',13);
title('BPSK, QPSK and 16-QAM over Rayleigh flat fading channel', 'Color','k', 'FontSize',14);
legend('BPSK (sim)','QPSK (sim)','16-QAM (sim)', ...
       'BPSK (theory)','QPSK (theory)','16-QAM (theory, approx.)', ...
       'Location','southwest', 'TextColor','k', 'Color','w', 'EdgeColor','k', 'FontSize',11);
% Note: BPSK and QPSK have identical BER vs Eb/No, so their curves overlap.
