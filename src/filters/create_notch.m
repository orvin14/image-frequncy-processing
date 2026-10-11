function H = create_notch(M, N, u0, v0, radius, filter_type, order)
%CREATE_NOTCH Create a pair of symmetric notch-reject filters.
%
%   u0 and v0 are offsets from the centered spectrum origin in pixels.
%   radius controls the rejected neighborhood around (+u0,+v0) and
%   (-u0,-v0). Supports ideal, Gaussian and Butterworth notch shapes.

validateattributes(u0, {'numeric'}, {'scalar','real','finite'});
validateattributes(v0, {'numeric'}, {'scalar','real','finite'});
validateattributes(radius, {'numeric'}, {'scalar','real','positive'});
validateattributes(order, {'numeric'}, {'scalar','real','positive'});

[x,y] = meshgrid((-floor(N/2)):(ceil(N/2)-1), ...
                 (-floor(M/2)):(ceil(M/2)-1));
D1 = sqrt((x-u0).^2 + (y-v0).^2);
D2 = sqrt((x+u0).^2 + (y+v0).^2);
t = lower(string(filter_type));

switch t
    case "ideal"
        H1 = double(D1 > radius);
        H2 = double(D2 > radius);
    case "gaussian"
        H1 = 1 - exp(-(D1.^2)/(2*radius^2));
        H2 = 1 - exp(-(D2.^2)/(2*radius^2));
    case "butterworth"
        H1 = ones(M,N);
        H2 = ones(M,N);
        nz1 = D1 > 0;
        nz2 = D2 > 0;
        H1(nz1) = 1 ./ (1 + (radius ./ D1(nz1)).^(2*order));
        H2(nz2) = 1 ./ (1 + (radius ./ D2(nz2)).^(2*order));
        H1(~nz1) = 0;
        H2(~nz2) = 0;
    otherwise
        error('Unknown notch type: %s', filter_type);
end
H = H1 .* H2;
end
