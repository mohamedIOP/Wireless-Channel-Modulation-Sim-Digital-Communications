function [mI, mQ] = rx_carrier_multiplier(y_inv, P)
% FIGURE BLOCK: multiplier "x" with phi(t) at the RECEIVER.
%   mI(t) = y_inv(t)*phi_I(t)       <- the only branch in Fig. 1 (BPSK)
%   mQ(t) = y_inv(t)*phi_Q(t)       <- second branch, QPSK / 16-QAM only
    mI = y_inv .* P.phi_I;
    if nargout > 1
        mQ = y_inv .* P.phi_Q;
    end
end
