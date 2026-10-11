function results = test_all()
%TEST_ALL Basic numerical regression tests for the IF4073 project.
% Run:
%   addpath(genpath('src')); results = test_all

fprintf('Running IF4073 Tugas 2 tests...\n');
results = struct();

M = 64; N = 80;
D0 = 12; n = 2;

% LPF/HPF shape and range
H_ilpf = create_lpf(M,N,D0,'ideal',n);
H_glpf = create_lpf(M,N,D0,'gaussian',n);
H_blpf = create_lpf(M,N,D0,'butterworth',n);
H_ihpf = create_hpf(M,N,D0,'ideal',n);
H_ghpf = create_hpf(M,N,D0,'gaussian',n);
H_bhpf = create_hpf(M,N,D0,'butterworth',n);

assert(isequal(size(H_ilpf),[M N]));
assert(all(H_glpf(:)>=0 & H_glpf(:)<=1));
assert(all(H_blpf(:)>=0 & H_blpf(:)<=1));
e1 = H_ihpf + H_ilpf - 1;
e2 = H_ghpf + H_glpf - 1;
e3 = H_bhpf + H_blpf - 1;
assert(max(abs(e1(:))) < 1e-12);
assert(max(abs(e2(:))) < 1e-12);
assert(max(abs(e3(:))) < 1e-12);
results.filters = true;

% FFT round trip grayscale and RGB
I = rand(M,N)*255;
Ir = ifft_transform(fft_transform(I));
assert(max(abs(I(:)-Ir(:))) < 1e-9);

RGB = rand(M,N,3)*255;
RGB2 = ifft_transform(fft_transform(RGB));
assert(max(abs(RGB(:)-RGB2(:))) < 1e-9);
results.fft = true;

% Brightness offset should shift a constant image by offset.
I0 = ones(M,N)*100;
F0 = fft_transform(I0);
F1 = create_brightness(F0,1,25);
I1 = ifft_transform(F1);
assert(abs(mean(I1(:))-125) < 1e-9);
results.brightness = true;

% Bandreject/notch masks
Hbr = create_bandreject(M,N,15,6,'ideal',2);
Hnotch = create_notch(M,N,10,7,3,'ideal',2);
assert(isequal(size(Hbr),[M N]) && isequal(size(Hnotch),[M N]));
assert(all(Hbr(:)>=0 & Hbr(:)<=1) && all(Hnotch(:)>=0 & Hnotch(:)<=1));
results.periodic = true;

% Motion model and restoration dimensions
Hmotion = motion_psf(M,N,0.5,30);
G = fft_transform(I);
Fi = inverse_filtering(G,Hmotion,0.05);
Fw = wiener_filtering(G,Hmotion,0.01);
assert(isequal(size(Fi),size(G)) && isequal(size(Fw),size(G)));
results.restoration = true;

fprintf('All tests passed.\n');
end
