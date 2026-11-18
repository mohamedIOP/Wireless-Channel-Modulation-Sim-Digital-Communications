function x = qpsk_mapper(b, Eb)
% QPSK symbol mapper (replaces the Polar NRZ Level Encoder of Fig. 1).
% Constellation of the handout (b0 b1):
%   00 -> -1-j    01 -> -1+j    11 -> +1+j    10 -> +1-j
% b0 selects the I level, b1 selects the Q level.  Es = 2*Eb, so each axis
% has amplitude sqrt(Eb).
    a = sqrt(Eb);
    B = reshape(b, 2, []);                       % row 1 = b0, row 2 = b1
    x = a * ((2*B(1,:) - 1) + 1j*(2*B(2,:) - 1));
end
