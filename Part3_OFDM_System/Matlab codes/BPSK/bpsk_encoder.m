function x = bpsk_encoder(b, Eb)
% Polar NRZ Level Encoder (reused from Part 2)
%   b_k = 0 -> x_k = -sqrt(Eb),   b_k = 1 -> x_k = +sqrt(Eb)
x = sqrt(Eb) * (2*b - 1);
end