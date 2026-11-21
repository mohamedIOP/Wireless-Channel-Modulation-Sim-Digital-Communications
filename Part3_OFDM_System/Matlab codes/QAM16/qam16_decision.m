function bhat = qam16_decision(rI, rQ, Eb)
% 16-QAM Decision Device, thresholds 0 and +-2a (reused from Part 2)
%   b0 = sign(I),  b1 = (|I| < 2)
%   b2 = sign(Q),  b3 = (|Q| < 2)
a  = sqrt(Eb/2.5);
I  = rI / a;   Q = rQ / a;
Bh = zeros(4, numel(rI));
Bh(1,:) = I > 0;
Bh(2,:) = abs(I) < 2;
Bh(3,:) = Q > 0;
Bh(4,:) = abs(Q) < 2;
bhat = Bh(:).';
end