function F_hat = inverse_filtering(G, H, epsilon)
%INVERSE_FILTERING Stabilized inverse filtering.
%
%   For |H| >= epsilon, Fhat = G/H.
%   For |H| < epsilon, the corresponding frequency is left unchanged
%   (Fhat = G) to avoid extreme noise amplification.

validateattributes(epsilon, {'numeric'}, {'scalar','real','positive'});
if ~isequal(size(G), size(H))
    error('G and H must have identical dimensions.');
end

F_hat = zeros(size(G));
stable = abs(H) >= epsilon;
F_hat(stable) = G(stable) ./ H(stable);
F_hat(~stable) = G(~stable);
end
