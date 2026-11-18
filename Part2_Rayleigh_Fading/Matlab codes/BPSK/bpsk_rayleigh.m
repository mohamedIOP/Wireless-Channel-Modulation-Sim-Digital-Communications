%% Project Part 2 - Block 1: BPSK over Rayleigh flat fading  (Fig. 1 of the handout)
%  Every line is tagged with the block of Fig. 1 that it implements:
%  b_k -> [Polar NRZ Level Encoder] -> x_k -> [x phi(t)] -> [h(t)] -> [Sigma + n(t)]
%      -> y_k -> [Channel Inversion] -> [x phi(t)] -> [integral 0..Tb] -> [Decision Device] -> bhat_k
clear; clc; close all;
rng(1);

%% Parameters
P       = sim_params();              % carrier phi(t), Tb, fc, samples per bit
Eb      = 1;                         % energy per bit
SNR_dB  = 0:2:30;                    % SNR = Eb/No in dB
SNR_lin = 10.^(SNR_dB/10);
Nbits_total = 1e6;                   % bits per SNR point (increase for smoother high-SNR points)
Nbatch      = 1e5;                   % bits per batch (keeps memory small)
Nloop       = Nbits_total / Nbatch;
BER     = zeros(1, numel(SNR_dB));

%% Simulation
for i = 1:numel(SNR_dB)                          % g. change the noise level, repeat a.-f.
    No   = Eb / SNR_lin(i);                      % SNR = Eb/No
    nerr = 0;
    for q = 1:Nloop
        b     = randi([0 1], 1, Nbatch);         % a.  random bit stream b_k
        x     = bpsk_encoder(b, Eb);             % [Fig.1: Polar NRZ Level Encoder]  b_k -> x_k
        s     = carrier_modulator(x, P);         % [Fig.1: multiplier x phi(t)]  (transmitter)
        [r,h] = rayleigh_channel(s, P);          % [Fig.1: h(t)]  c. complex channel hr + j*hi
        y     = add_awgn(r, No, P);              % [Fig.1: Sigma, n(t)]  c./d. noise nc, ns -> y_k
        y_inv = channel_inversion(y, h);         % [Fig.1: Channel Inversion]  e. h known at Rx
        mI    = rx_carrier_multiplier(y_inv, P); % [Fig.1: multiplier x phi(t)]  (receiver)
        rI    = integrator(mI, P);               % [Fig.1: integral from 0 to Tb]
        bhat  = bpsk_decision(rI);               % [Fig.1: Decision Device, threshold = 0]
        nerr  = nerr + sum(b ~= bhat);           % count bit errors
    end
    BER(i) = nerr / Nbits_total;                 % f. BER for this SNR
    fprintf('BPSK  Eb/No = %2d dB   BER = %.3e\n', SNR_dB(i), BER(i));
end

%% Theory (Rayleigh, BPSK): Pb = 0.5*(1 - sqrt(g/(1+g)))
BER_th = 0.5 * (1 - sqrt(SNR_lin ./ (1 + SNR_lin)));
save('bpsk_results.mat', 'SNR_dB', 'BER', 'BER_th');

%% Data for the constellation plot (same chain, Eb/No = 15 dB)
Nsc = 5000;  No = Eb / 10^(15/10);
bs = randi([0 1], 1, Nsc);
xs = bpsk_encoder(bs, Eb);                       % [Polar NRZ Level Encoder]
ss = carrier_modulator(xs, P);                   % [x phi(t)] Tx
[rs, hs] = rayleigh_channel(ss, P);              % [h(t)]
ys = add_awgn(rs, No, P);                        % [Sigma + n(t)]
yi = channel_inversion(ys, hs);                  % [Channel Inversion]
[mIs, mQs] = rx_carrier_multiplier(yi, P);       % [x phi(t)] Rx
zs = integrator(mIs, P) + 1j*integrator(mQs, P); % rQ only used to draw the 2-D scatter

%% ===================== PLOTS (end of block) =====================
blue = [0 0.447 0.741];  red = [0.85 0.15 0.10];

% ---- Figure 1: BER vs Eb/No ----
figure('Name','BPSK BER','Color','w','Position',[100 100 820 580]);
semilogy(SNR_dB, BER, '-o', 'Color', blue, 'LineWidth', 2.5, ...
         'MarkerSize', 8, 'MarkerFaceColor', blue); hold on;
semilogy(SNR_dB, BER_th, '--', 'Color', red, 'LineWidth', 2.5);
grid on; ylim([1e-5 1]); xlim([min(SNR_dB) max(SNR_dB)]);
set(gca, 'Color','w', 'XColor','k', 'YColor','k', 'GridColor','k', ...
         'GridAlpha',0.25, 'MinorGridAlpha',0.12, 'FontSize',12, 'LineWidth',1);
xlabel('E_b/N_o (dB)', 'Color','k', 'FontSize',13);
ylabel('Bit Error Rate (BER)', 'Color','k', 'FontSize',13);
title('BPSK BER', 'Color','k', 'FontSize',14);
legend('Simulation', 'Theory', 'Location','southwest', ...
       'TextColor','k', 'Color','w', 'EdgeColor','k', 'FontSize',12);

% ---- Figure 2: constellation after correlator at 15 dB ----
figure('Name','BPSK constellation','Color','w','Position',[100 100 700 640]);
plot(real(zs), imag(zs), '.', 'Color', blue, 'MarkerSize', 9); hold on;
plot(sqrt(Eb)*[-1 1], [0 0], 'x', 'Color', red, 'MarkerSize', 14, 'LineWidth', 3);
xline(0, 'k-'); yline(0, 'k-');
axis equal; xlim([-3 3]); ylim([-3 3]); grid on;
set(gca, 'Color','w', 'XColor','k', 'YColor','k', 'GridColor','k', ...
         'GridAlpha',0.25, 'MinorGridAlpha',0.12, 'FontSize',12, 'LineWidth',1);
xlabel('I', 'Color','k', 'FontSize',13); ylabel('Q', 'Color','k', 'FontSize',13);
title('BPSK Constellation, E_b/N_o = 15 dB', 'Color','k', 'FontSize',14);
legend('Correlator output', 'Ideal symbols', 'Location','northeast', ...
       'TextColor','k', 'Color','w', 'EdgeColor','k', 'FontSize',11);
% Axes are zoomed: deep fades (tiny |h|) amplify the noise and throw a few points far away.
