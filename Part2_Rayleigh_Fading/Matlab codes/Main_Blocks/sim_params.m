function P = sim_params()
% Common simulation parameters (time-domain, passband simulation of Fig. 1).
%   T   : symbol duration (T = Tb for BPSK). Time is normalised, T = 1 s.
%   fc  : carrier frequency, chosen so that there is an INTEGER number of
%         carrier cycles inside one symbol (makes the correlator exact).
%   Ns  : number of time samples per symbol (oversampling).
%   phi_I(t) =  sqrt(2/T)*cos(2*pi*fc*t)   <- the carrier phi(t) of Fig. 1
%   phi_Q(t) = -sqrt(2/T)*sin(2*pi*fc*t)   <- 90-degree carrier (QPSK / 16-QAM only)
    P.T     = 1;
    P.fc    = 2/P.T;                         % 2 carrier cycles per symbol
    P.Ns    = 16;                            % samples per symbol (must be even)
    P.dt    = P.T/P.Ns;                      % sampling interval
    P.fs    = 1/P.dt;                        % sampling frequency
    P.t     = (0:P.Ns-1).' * P.dt;           % time axis of ONE symbol interval [0,T)
    P.cos   = cos(2*pi*P.fc*P.t);            % cos(2*pi*fc*t)
    P.sin   = sin(2*pi*P.fc*P.t);            % sin(2*pi*fc*t)
    P.phi_I =  sqrt(2/P.T) * P.cos;          % phi(t) of Fig. 1
    P.phi_Q = -sqrt(2/P.T) * P.sin;          % quadrature carrier
end
