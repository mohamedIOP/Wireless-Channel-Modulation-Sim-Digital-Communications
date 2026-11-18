function s = carrier_modulator(x, P)
% FIGURE BLOCK: multiplier "x" with phi(t) at the TRANSMITTER.
% Every symbol x_k multiplies the carrier during its symbol interval:
%   s(t) = real(x_k)*phi_I(t) + imag(x_k)*phi_Q(t)
% For BPSK x_k is real, so s(t) = x_k*phi(t) exactly as in Fig. 1.
% Output: Ns x N matrix, column k = samples of the k-th symbol interval.
    s = P.phi_I * real(x) + P.phi_Q * imag(x);
end
