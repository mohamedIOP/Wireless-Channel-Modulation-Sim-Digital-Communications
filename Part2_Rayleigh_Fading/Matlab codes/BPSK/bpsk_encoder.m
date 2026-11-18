function x = bpsk_encoder(b, Eb)
% FIGURE BLOCK: "Polar NRZ Level Encoder"   (b_k -> x_k)
%   b_k = 0 -> x_k = -sqrt(Eb),   b_k = 1 -> x_k = +sqrt(Eb)
    x = sqrt(Eb) * (2*b - 1);
end
