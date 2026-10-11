function H = create_hpf(M, N, cutoff, filter_type, order)
%CREATE_HPF Create Ideal, Gaussian, or Butterworth HPF H(u,v).

validateattributes(M, {'numeric'}, {'scalar','integer','positive'});
validateattributes(N, {'numeric'}, {'scalar','integer','positive'});
validateattributes(cutoff, {'numeric'}, {'scalar','positive'});
validateattributes(order, {'numeric'}, {'scalar','positive'});

[u,v] = meshgrid((-floor(N/2)):(ceil(N/2)-1), ...
                 (-floor(M/2)):(ceil(M/2)-1));
D = sqrt(u.^2 + v.^2);
t = lower(string(filter_type));

switch t
    case "ideal"
        H = double(D > cutoff);
    case "gaussian"
        H = 1 - exp(-(D.^2) ./ (2*cutoff^2));
    case "butterworth"
        H = ones(M,N);
        nz = D > 0;
        H(nz) = 1 ./ (1 + (cutoff ./ D(nz)).^(2*order));
        H(~nz) = 0;
    otherwise
        error('Unknown HPF type: %s', filter_type);
end
end
