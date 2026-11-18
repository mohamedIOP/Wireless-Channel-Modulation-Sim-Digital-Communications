function r = integrator(m, P)
% FIGURE BLOCK: integrator  integral from 0 to Tb of ( . ) dt
% Numerical integration over one symbol interval (sum of samples * dt).
    r = P.dt * sum(m, 1);
end
