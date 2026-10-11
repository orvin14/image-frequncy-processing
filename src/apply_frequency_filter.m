function I_out = apply_frequency_filter(I, H)
%APPLY_FREQUENCY_FILTER Apply a manually-created centered frequency mask.
%
%   The same H is applied independently to each RGB channel.

F = fft_transform(I);
if ndims(F) == 2
    F_filtered = F .* H;
else
    F_filtered = zeros(size(F));
    for c = 1:3
        F_filtered(:,:,c) = F(:,:,c) .* H;
    end
end
I_out = ifft_transform(F_filtered);
I_out = min(max(I_out,0),255);
end
