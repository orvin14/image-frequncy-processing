function F = fft_transform(I)
%FFT_TRANSFORM Centered 2-D FFT for grayscale or RGB images.
%   F = fft_transform(I) returns fftshift(fft2(...)) for each channel.
%
%   Input can be MxN or MxNx3. Output has the same spatial dimensions.

I = double(I);
if ndims(I) == 2
    F = fftshift(fft2(I));
elseif ndims(I) == 3 && size(I,3) == 3
    F = zeros(size(I));
    for c = 1:3
        F(:,:,c) = fftshift(fft2(I(:,:,c)));
    end
else
    error('Input must be grayscale MxN or RGB MxNx3.');
end
end
