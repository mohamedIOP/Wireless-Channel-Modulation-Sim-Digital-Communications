function [r, h] = rayleigh_channel(s, P)
% FIGURE BLOCK: h(t) = (hr + j*hi)*delta(t)   (Rayleigh flat fading)
%   hr, hi ~ N(0, 1/2)  ->  amplitude Ah Rayleigh, phase thetah uniform [0,2*pi)
% The channel is flat (delta) and constant during one symbol, independent
% from symbol to symbol.  The complex gain acts on the analytic signal of the
% real passband signal:   r(t) = Re{ h * s_analytic(t) }
%   (amplitude Ah scaling + phase rotation thetah of the carrier)
    N = size(s, 2);
    h = sqrt(1/2) * (randn(1,N) + 1j*randn(1,N));
    r = real(analytic_signal(s) .* h);
end
