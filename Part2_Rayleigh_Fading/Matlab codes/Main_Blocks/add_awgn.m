function y = add_awgn(r, No, P)
% FIGURE BLOCK: adder "Sigma" with n(t)    (y(t) = r(t) + n(t))
%   n(t) = nc(t)*cos(wc*t) - ns(t)*sin(wc*t)
% nc(t), ns(t): zero-mean Gaussian, independent.
% In the sampled simulation their per-sample variance is (No/2)*fs, which makes
% the noise at the correlator output have variance No/2 per component
% (the nc, ns variance No/2 given in the handout).
    [Ns, N] = size(r);
    sigma2  = (No/2) * P.fs;
    nc = sqrt(sigma2) * randn(Ns, N);
    ns = sqrt(sigma2) * randn(Ns, N);
    n  = nc .* P.cos - ns .* P.sin;
    y  = r + n;
end
