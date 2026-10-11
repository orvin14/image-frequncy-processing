function I = ifft_transform(F)
%IFFT_TRANSFORM Inverse of FFT_TRANSFORM for grayscale or RGB.
%   I = ifft_transform(F) applies ifft2(ifftshift(...)) per channel.
%   The result is real-valued and is not clipped automatically.

if ndims(F) == 2
    I = real(ifft2(ifftshift(F)));
elseif ndims(F) == 3 && size(F,3) == 3
    I = zeros(size(F));
    for c = 1:3
        I(:,:,c) = real(ifft2(ifftshift(F(:,:,c))));
    end
else
    error('Input must be grayscale MxN or RGB MxNx3.');
end
end
