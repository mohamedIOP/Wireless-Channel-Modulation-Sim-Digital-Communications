function c_deint = block_deinterleaver(c_int, n_rows, n_cols)
% BLOCK 2 (Rx): Matrix Block De-interleaver
%   Exact inverse of block_interleaver:
%   Writes bits column-by-column into (n_rows x n_cols), reads row-by-row.
%
% Inputs:
%   c_int  : Interleaved bits matrix (N_coded x N_sym)
%   n_rows : Number of interleaver rows
%   n_cols : Number of interleaver columns
%
% Output:
%   c_deint: De-interleaved bits matrix (same size as c_int)

L = n_rows * n_cols;
assert(mod(numel(c_int), L) == 0, ...
    'Total bits (%d) must be a multiple of interleaver size (%d x %d = %d).', ...
    numel(c_int), n_rows, n_cols, L);

N_blocks = numel(c_int) / L;

% Write column-by-column into (n_rows x n_cols), transpose, then read column-by-column (= row-by-row)
tmp     = reshape(c_int, n_rows, n_cols, N_blocks);
tmp     = permute(tmp, [2, 1, 3]);        % now (n_cols x n_rows x N_blocks)
c_deint = reshape(tmp, size(c_int));
end