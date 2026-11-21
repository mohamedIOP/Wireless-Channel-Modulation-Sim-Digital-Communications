function c = rep_encoder(b, N_coded, use_coding)
% BLOCK 1 (Tx): Channel Coding (No Coding or Rate 1/5 Repetition Code)
%
% Inputs:
%   b          : Input data bits matrix (N_data x N_sym), each column = 1 OFDM symbol
%                - No coding      : N_data = N_coded (256 for BPSK, 1024 for 16-QAM)
%                - Rate 1/5 coding: N_data = floor(N_coded / 5) (51 for BPSK, 204 for 16-QAM)
%   N_coded    : Total coded bits per OFDM symbol (256 for BPSK, 1024 for 16-QAM)
%   use_coding : Boolean (false = no coding, true = rate 1/5 repetition)
%
% Output:
%   c          : Coded bits matrix (N_coded x N_sym)

if ~use_coding
    assert(size(b, 1) == N_coded, ...
        'No-coding mode requires %d rows per OFDM symbol.', N_coded);
    c = b;
    return;
end

rep_factor = 5;
N_data = floor(N_coded / rep_factor);       % 51 (BPSK) or 204 (16-QAM)
N_pad  = N_coded - rep_factor * N_data;     % 1  (BPSK) or 4   (16-QAM)
N_sym  = size(b, 2);

assert(size(b, 1) == N_data, ...
    'Rate 1/5 coding requires %d data bits per OFDM symbol (got %d).', N_data, size(b, 1));

% Repeat each bit 5 times along columns, then append zero padding
c_rep = repelem(b, rep_factor, 1);
c     = [c_rep; zeros(N_pad, N_sym)];
end