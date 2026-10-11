function F_hat = wiener_filtering(G, H, K)
%WIENER_FILTERING Frequency-domain Wiener filtering.
%
%   Fhat = [1/H * |H|^2/(|H|^2+K)] .* G
%   with a numerically stable equivalent form:
%   Fhat = conj(H)./(|H|^2+K) .* G.
%
%   K is the noise-to-signal ratio (NSR).

validateattributes(K, {'numeric'}, {'scalar','real','finite','nonnegative'});
if ~isequal(size(G), size(H))
    error('G and H must have identical dimensions.');
end

F_hat = (conj(H) ./ (abs(H).^2 + K)) .* G;
end
