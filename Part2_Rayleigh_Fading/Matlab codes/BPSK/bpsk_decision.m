function bhat = bpsk_decision(rI)
% FIGURE BLOCK: "Decision Device", Threshold = 0
%   rI > 0 -> bhat = 1,   rI <= 0 -> bhat = 0
    bhat = double(rI > 0);
end
