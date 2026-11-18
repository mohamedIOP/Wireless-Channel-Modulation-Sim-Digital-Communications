function x = qam16_mapper(b, Eb)
% 16-QAM symbol mapper (replaces the Polar NRZ Level Encoder of Fig. 1).
% Constellation of the handout (b0 b1 b2 b3):
%   b0b1 -> I level, b2b3 -> Q level, both Gray coded:
%   00 -> -3,  01 -> -1,  11 -> +1,  10 -> +3
% Average Es = 10*a^2 = 4*Eb  ->  a = sqrt(Eb/2.5)
    a = sqrt(Eb/2.5);
    B = reshape(b, 4, []);                       % rows = b0 b1 b2 b3
    I = (2*B(1,:) - 1) .* (3 - 2*B(2,:));
    Q = (2*B(3,:) - 1) .* (3 - 2*B(4,:));
    x = a * (I + 1j*Q);
end
