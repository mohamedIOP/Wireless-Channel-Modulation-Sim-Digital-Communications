function bhat = qam16_decision(rI, rQ, Eb)
% FIGURE BLOCK: "Decision Device", 16-QAM (thresholds 0, +-2a)
% After normalising by a the levels are -3,-1,+1,+3, decision thresholds -2,0,+2.
%   b0 = sign(I),  b1 = (|I| < 2)   (inner/outer level)
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
