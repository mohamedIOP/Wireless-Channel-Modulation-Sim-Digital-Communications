function b_hat = rep_decoder(c_hat, N_coded, use_coding)
% BLOCK 1 (Rx): Channel Decoding (No Coding or Rate 1/5 Hard Majority Voting)
%
% Inputs:
%   c_hat      : Received hard-decision bits matrix (N_coded x N_sym)
%   N_coded    : Total coded bits per OFDM symbol (256 for BPSK, 1024 for 16-QAM)
%   use_coding : Boolean (false = no coding, true = rate 1/5 repetition)
%
% Output:
%   b_hat      : Decoded data bits matrix (N_data x N_sym)

assert(size(c_hat, 1) == N_coded, ...
    'Expected %d rows per OFDM symbol (got %d).', N_coded, size(c_hat, 1));

if ~use_coding
    b_hat = c_hat;
    return;
end

rep_factor = 5;
N_data = floor(N_coded / rep_factor);       % 51 (BPSK) or 204 (16-QAM)
N_sym  = size(c_hat, 2);

% 1. Strip the padded zeros at the end of each OFDM symbol
c_valid = c_hat(1 : rep_factor * N_data, :);

% 2. Group every 5 repeated bits into columns and apply majority voting (>= 3)
blocks = reshape(c_valid, rep_factor, []);  % 5 x (N_data * N_sym)
votes  = sum(blocks, 1) >= 3;               % logical 1 x (N_data * N_sym)
b_hat  = double(reshape(votes, N_data, N_sym));
end