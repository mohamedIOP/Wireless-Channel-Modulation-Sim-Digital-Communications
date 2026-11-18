function bhat = qpsk_decision(rI, rQ)
% FIGURE BLOCK: "Decision Device" (threshold 0 on each axis), QPSK
%   b0 = (I > 0),  b1 = (Q > 0)   -> bits interleaved as b0 b1 b0 b1 ...
    Bh = zeros(2, numel(rI));
    Bh(1,:) = rI > 0;
    Bh(2,:) = rQ > 0;
    bhat = Bh(:).';
end
