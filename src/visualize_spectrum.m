function S = visualize_spectrum(F)
%VISUALIZE_SPECTRUM Return normalized log-magnitude spectrum for display.
S = log(1 + abs(F));
if ndims(S) == 3
    S = mean(S,3);
end
mx = max(S(:));
if mx > 0
    S = S ./ mx;
end
end
