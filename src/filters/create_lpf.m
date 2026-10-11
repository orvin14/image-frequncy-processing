function H = create_lpf(M, N, cutoff, filter_type, order)
%CREATE_LPF Create Ideal, Gaussian, or Butterworth LPF H(u,v).
%
%   H = create_lpf(M,N,cutoff,filter_type,order)
%   filter_type: 'ideal' | 'gaussian' | 'butterworth'
%   cutoff is D0 in frequency-pixel units.
%   order is only used by the Butterworth type; it is ignored otherwise.

validateattributes(M, {'numeric'}, {'scalar','integer','positive'});
validateattributes(N, {'numeric'}, {'scalar','integer','positive'});
validateattributes(cutoff, {'numeric'}, {'scalar','positive'});

[u,v] = meshgrid((-floor(N/2)):(ceil(N/2)-1), ...
                 (-floor(M/2)):(ceil(M/2)-1));
D = sqrt(u.^2 + v.^2);
t = lower(string(filter_type));

switch t
    case "ideal"
        H = double(D <= cutoff);
    case "gaussian"
        H = exp(-(D.^2) ./ (2*cutoff^2));
    case "butterworth"
        if nargin < 5 || isempty(order)
            order = 2;
        end
        validateattributes(order, {'numeric'}, {'scalar','positive'});
        H = 1 ./ (1 + (D ./ cutoff).^(2*order));
    otherwise
        error('Unknown LPF type: %s', filter_type);
end
end
