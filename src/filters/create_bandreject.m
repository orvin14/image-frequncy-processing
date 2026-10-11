function H = create_bandreject(M, N, D0, W, filter_type, order)
%CREATE_BANDREJECT Create Ideal, Gaussian, or Butterworth bandreject mask.
%
%   The reject band is centered at D0 and has width W.
%   order is only used by the Butterworth type; it is ignored otherwise.

validateattributes(D0, {'numeric'}, {'scalar','real','positive'});
validateattributes(W, {'numeric'}, {'scalar','real','positive'});

[u,v] = meshgrid((-floor(N/2)):(ceil(N/2)-1), ...
                 (-floor(M/2)):(ceil(M/2)-1));
D = sqrt(u.^2 + v.^2);
t = lower(string(filter_type));

switch t
    case "ideal"
        H = ones(M,N);
        H(D >= D0 - W/2 & D <= D0 + W/2) = 0;
    case "gaussian"
        % Gaussian bandreject: 1 - Gaussian bandpass.
        ratio = (D.^2 - D0^2) ./ max(D .* W, eps);
        H = 1 - exp(-0.5 .* ratio.^2);
        H(D == 0) = 1;
    case "butterworth"
        if nargin < 6 || isempty(order)
            order = 2;
        end
        validateattributes(order, {'numeric'}, {'scalar','real','positive'});
        H = ones(M,N);
        denom = D.^2 - D0^2;
        nz = abs(denom) > eps;
        H(nz) = 1 ./ (1 + (D(nz).*W ./ denom(nz)).^(2*order));
        H(~nz) = 0;
    otherwise
        error('Unknown bandreject type: %s', filter_type);
end
end
