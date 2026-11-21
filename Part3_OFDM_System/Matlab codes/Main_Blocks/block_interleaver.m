function c_int = block_interleaver(c, n_rows, n_cols)
% BLOCK 2 (Tx): Matrix Block Interleaver
%   Writes bits row-by-row into an (n_rows x n_cols) matrix,
%   then reads them out column-by-column.
%
% Inputs:
%   c      : Coded bits matrix (N_coded x N_sym)
%   n_rows : Number of interleaver rows    (e.g., 16 for BPSK, 32 for 16-QAM)
%   n_cols : Number of interleaver columns (e.g., 16 for BPSK, 32 for 16-QAM)
%
% Output:
%   c_int  : Interleaved bits matrix (same size as c)

L = n_rows * n_cols;
assert(mod(numel(c), L) == 0, ...
    'Total bits (%d) must be a multiple of interleaver size (%d x %d = %d).', ...
    numel(c), n_rows, n_cols, L);

N_blocks = numel(c) / L;

% MATLAB is column-major, so reshape to (n_cols x n_rows) then transpose
% each 2D page -> equivalent to writing row-by-row into (n_rows x n_cols)
tmp   = reshape(c, n_cols, n_rows, N_blocks);
tmp   = permute(tmp, [2, 1, 3]);          % now (n_rows x n_cols x N_blocks)
c_int = reshape(tmp, size(c));            % reads out column-by-column
end