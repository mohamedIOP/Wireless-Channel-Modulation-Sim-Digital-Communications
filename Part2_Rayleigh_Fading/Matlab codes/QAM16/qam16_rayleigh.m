%% Project Part 2 - Block 3: 16-QAM over Rayleigh flat fading
%  Same chain as Fig. 1 (BPSK) but with TWO orthogonal carriers phi_I(t), phi_Q(t):
%  b -> [Mapper] -> x=I+jQ -> [x phi(t)] -> [h(t)] -> [Sigma + n(t)] -> [Channel Inversion]
%     -> [x phi_I, x phi_Q] -> [integral 0..T] x2 -> [Decision Device] -> bhat
%  Constellation (b0b1b2b3): b0b1 -> I, b2b3 -> Q, Gray: 00->-3, 01->-1, 11->+1, 10->+3
clear; clc; close all;
rng(3);

%% Parameters
P       = sim_params();
Eb      = 1;
SNR_dB  = 0:2:30;
SNR_lin = 10.^(SNR_dB/10);
Nbits_total = 1e6;                   % must be a multiple of 4
Nbatch      = 1e5;                   % must be a multiple of 4
Nloop       = Nbits_total / Nbatch;
BER     = zeros(1, numel(SNR_dB));

%% Simulation
for i = 1:numel(SNR_dB)                          % g. change the noise level
    No   = Eb / SNR_lin(i);                      % SNR = Eb/No
    nerr = 0;
    for q = 1:Nloop
        b     = randi([0 1], 1, Nbatch);         % a.  random bit stream b_k
        x     = qam16_mapper(b, Eb);             % [Fig.1: Level Encoder] -> 16-QAM symbols (4 bits/symbol)
        s     = carrier_modulator(x, P);         % [Fig.1: multiplier x phi(t)] I and Q carriers (Tx)
        [r,h] = rayleigh_channel(s, P);          % [Fig.1: h(t)]  complex channel hr + j*hi
        y     = add_awgn(r, No, P);              % [Fig.1: Sigma, n(t)]  noise nc, ns
        y_inv = channel_inversion(y, h);         % [Fig.1: Channel Inversion]  h known at Rx
        [mI,mQ] = rx_carrier_multiplier(y_inv, P);% [Fig.1: multiplier x phi(t)] I and Q branches (Rx)
        rI    = integrator(mI, P);               % [Fig.1: integral 0..T]  I branch
        rQ    = integrator(mQ, P);               % [Fig.1: integral 0..T]  Q branch
        bhat  = qam16_decision(rI, rQ, Eb);      % [Fig.1: Decision Device, thresholds 0 and +-2a]
        nerr  = nerr + sum(b ~= bhat);
    end
    BER(i) = nerr / Nbits_total;                 % f. BER
    fprintf('16QAM Eb/No = %2d dB   BER = %.3e\n', SNR_dB(i), BER(i));
end

%% Theory (Rayleigh, Gray 16-QAM, nearest-neighbour approximation)
BER_th = (3/4) * 0.5 .* (1 - sqrt(0.4*SNR_lin ./ (1 + 0.4*SNR_lin)));
save('qam16_results.mat', 'SNR_dB', 'BER', 'BER_th');

%% Data for the constellation plot (same chain, Eb/No = 20 dB)
Nsc = 5000;  No = Eb / 10^(20/10);
bs = randi([0 1], 1, 4*Nsc);
xs = qam16_mapper(bs, Eb);                       % [Level Encoder]
ss = carrier_modulator(xs, P);                   % [x phi(t)] Tx
[rs, hs] = rayleigh_channel(ss, P);              % [h(t)]
ys = add_awgn(rs, No, P);                        % [Sigma + n(t)]
yi = channel_inversion(ys, hs);                  % [Channel Inversion]
[mIs, mQs] = rx_carrier_multiplier(yi, P);       % [x phi(t)] Rx
zs = integrator(mIs, P) + 1j*integrator(mQs, P); % [integrators]

%% ===================== PLOTS (end of block) =====================
blue = [0 0.447 0.741];  red = [0.85 0.15 0.10];
green = [0.10 0.60 0.20];  purple = [0.55 0.10 0.65];
a = sqrt(Eb/2.5);

% ---- Figure 1: BER vs Eb/No ----
figure('Name','16-QAM BER','Color','w','Position',[100 100 820 580]);
semilogy(SNR_dB, BER, '-^', 'Color', purple, 'LineWidth', 2.5, ...
         'MarkerSize', 8, 'MarkerFaceColor', purple); hold on;
semilogy(SNR_dB, BER_th, '--', 'Color', green, 'LineWidth', 2.5);
grid on; ylim([1e-5 1]); xlim([min(SNR_dB) max(SNR_dB)]);
set(gca, 'Color','w', 'XColor','k', 'YColor','k', 'GridColor','k', ...
         'GridAlpha',0.25, 'MinorGridAlpha',0.12, 'FontSize',12, 'LineWidth',1);
xlabel('E_b/N_o (dB)', 'Color','k', 'FontSize',13);
ylabel('Bit Error Rate (BER)', 'Color','k', 'FontSize',13);
title('16-QAM BER', 'Color','k', 'FontSize',14);
legend('Simulation', 'Theory (approx.)', 'Location','southwest', ...
       'TextColor','k', 'Color','w', 'EdgeColor','k', 'FontSize',12);

% ---- Figure 2: constellation after correlators at 20 dB ----
figure('Name','16-QAM constellation','Color','w','Position',[100 100 700 640]);
plot(real(zs), imag(zs), '.', 'Color', blue, 'MarkerSize', 9); hold on;
[Ig, Qg] = meshgrid([-3 -1 1 3]);
xi = a * (Ig(:) + 1j*Qg(:));
plot(real(xi), imag(xi), 'x', 'Color', red, 'MarkerSize', 14, 'LineWidth', 3);
xline(0, 'k-'); yline(0, 'k-');
axis equal; xlim([-4 4]); ylim([-4 4]); grid on;
set(gca, 'Color','w', 'XColor','k', 'YColor','k', 'GridColor','k', ...
         'GridAlpha',0.25, 'MinorGridAlpha',0.12, 'FontSize',12, 'LineWidth',1);
xlabel('I', 'Color','k', 'FontSize',13); ylabel('Q', 'Color','k', 'FontSize',13);
title('16-QAM Constellation, E_b/N_o = 20 dB', 'Color','k', 'FontSize',14);
legend('Correlator output', 'Ideal symbols', 'Location','northeast', ...
       'TextColor','k', 'Color','w', 'EdgeColor','k', 'FontSize',11);
