function H = motion_psf(M, N, d, theta)
%MOTION_PSF Frequency-domain degradation function for linear motion blur.
%
%   d     : motion length in frequency-pixel units
%   theta : motion angle in degrees
%
%   H(u,v) = T/[pi(ua+vb)] * sin(pi(ua+vb)) * exp(-j*pi(ua+vb))
%   with a=d/T*cos(theta), b=d/T*sin(theta), T=1.
%
%   The limit at ua+vb=0 is H=1.

validateattributes(d, {'numeric'}, {'scalar','real','positive'});
validateattributes(theta, {'numeric'}, {'scalar','real','finite'});

T = 1;
a = (d/T) * cosd(theta);
b = (d/T) * sind(theta);

[u,v] = meshgrid((-floor(N/2)):(ceil(N/2)-1), ...
                 (-floor(M/2)):(ceil(M/2)-1));
q = u*a + v*b;

H = ones(M,N);
nz = abs(q) > 1e-12;
H(nz) = (T ./ (pi*q(nz))) .* sin(pi*q(nz)) .* exp(-1i*pi*q(nz));
end
