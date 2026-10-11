function F_out = create_brightness(F_uv, factor, offset)
%CREATE_BRIGHTNESS Frequency-domain brightness adjustment.
%
%   factor scales the spectrum (including DC).
%   offset is an additive spatial-domain brightness amount in [0,255]
%   units. With MATLAB's FFT convention, adding offset*M*N to the
%   centered DC coefficient changes the reconstructed image by offset.
%
%   F_uv may be MxN or MxNx3.

validateattributes(factor, {'numeric'}, {'scalar','real','finite','nonnegative'});
validateattributes(offset, {'numeric'}, {'scalar','real','finite'});

F_out = factor .* F_uv;
M = size(F_uv,1);
N = size(F_uv,2);
dcRow = floor(M/2) + 1;
dcCol = floor(N/2) + 1;

if ndims(F_uv) == 2
    F_out(dcRow,dcCol) = F_out(dcRow,dcCol) + offset*M*N;
elseif ndims(F_uv) == 3 && size(F_uv,3) == 3
    for c = 1:3
        F_out(dcRow,dcCol,c) = F_out(dcRow,dcCol,c) + offset*M*N;
    end
else
    error('F_uv must be grayscale or RGB.');
end
end
