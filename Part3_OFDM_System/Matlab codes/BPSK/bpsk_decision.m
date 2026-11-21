function bhat = bpsk_decision(rI)
% Decision Device, Threshold = 0 (reused from Part 2)
%   rI > 0 -> bhat = 1,   rI <= 0 -> bhat = 0
bhat = double(rI > 0);
end