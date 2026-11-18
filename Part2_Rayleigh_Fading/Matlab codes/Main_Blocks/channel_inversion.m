function y_inv = channel_inversion(y, h)
% FIGURE BLOCK: "Channel Inversion"  (channel h known at the receiver)
% Divides the received passband signal by the complex channel gain:
%   y_inv(t) = Re{ y_analytic(t) / h }
% This undoes both the amplitude Ah and the phase thetah of the channel.
    y_inv = real(analytic_signal(y) ./ h);
end
