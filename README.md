# Tugas 2 IF4073 — Pemrosesan Citra dalam Ranah Frekuensi & Restorasi

Implementasi individu berbasis MATLAB untuk smoothing/low-pass, high-pass,
frequency-domain brightness, periodic-noise restoration, dan motion-blur
restoration.

## Struktur

```text
Tugas2_IF4073_NIM/
├── src/
│   ├── main_gui.m
│   ├── apply_frequency_filter.m
│   ├── visualize_spectrum.m
│   ├── core/
│   │   ├── fft_transform.m
│   │   └── ifft_transform.m
│   ├── filters/
│   │   ├── create_lpf.m
│   │   ├── create_hpf.m
│   │   ├── create_brightness.m
│   │   ├── create_bandreject.m
│   │   └── create_notch.m
│   └── restoration/
│       ├── motion_psf.m
│       ├── inverse_filtering.m
│       └── wiener_filtering.m
├── dataset/
├── output/
├── tests/
│   ├── test_all.m
│   └── check_constraints.m
├── setup_paths.m
└── README.md
```

## Menjalankan

Buka MATLAB pada root project, lalu:

```matlab
setup_paths
main_gui
```

GUI memiliki satu window terpadu dengan:
- Input image
- Magnitude spectrum `log(1 + |F|)`
- Mask/fungsi transfer `H(u,v)`
- Output image
- Tab LPF, HPF, Brightness, Periodic Noise, dan Motion Restoration
- Parameter interaktif untuk `D0`, `n`, `W`, `u0/v0`, radius, `K`, `theta`,
  `d`, dan `epsilon`

Input grayscale dan RGB diproses; filter frekuensi diterapkan independen
pada channel RGB.

## Implementasi filter

### LPF
- Ideal LPF
- Gaussian LPF
- Butterworth LPF

### HPF
- Ideal HPF
- Gaussian HPF
- Butterworth HPF

### Brightness
`create_brightness` mengubah spektrum dengan faktor `k` dan memodifikasi
komponen DC menggunakan offset. Dengan konvensi FFT MATLAB, penambahan
`offset*M*N` pada koefisien DC menghasilkan perubahan brightness sebesar
`offset` pada citra spasial sebelum clipping `[0,255]`.

### Periodic noise
- Bandreject: Ideal / Gaussian / Butterworth
- Notch reject: pasangan notch simetris `(+u0,+v0)` dan `(-u0,-v0)`
- Spektrum magnitude ditampilkan agar spike noise dapat diidentifikasi

### Motion blur
Fungsi transfer mengikuti model pada rencana:
`H = T/(pi*q) * sin(pi*q) * exp(-j*pi*q)`,
dengan `q = u*a + v*b`.

Restorasi:
- Stabilized inverse filtering dengan threshold `epsilon`
- Wiener filtering dengan NSR `K`

## Constraint

Implementasi backend tidak memakai fungsi:
`imgaussfilt`, `imsharpen`, `deconvwnr`, `wiener2`, `imfilter`, atau
`fspecial`.

FFT yang digunakan adalah `fft2`, `ifft2`, `fftshift`, dan `ifftshift`;
fungsi transfer dibuat dari operasi matriks dasar.

## Pengujian

Jalankan:

```matlab
addpath(genpath('src'));
test_all
check_constraints
```

`test_all` memeriksa:
1. Ukuran/range mask LPF dan HPF.
2. Hubungan komplementer LPF/HPF.
3. Round-trip FFT grayscale dan RGB.
4. Efek DC brightness.
5. Ukuran/range bandreject dan notch.
6. Dimensi motion PSF, inverse, dan Wiener.

## Catatan tentang App Designer

Versi yang diberikan menggunakan `uifigure` programmatic GUI dalam
`src/main_gui.m`. Ini sengaja dibuat sebagai source-code MATLAB yang
portable dan mudah direview/dijalankan tanpa file `.mlapp` biner.

Secara fungsional ia tetap merupakan satu GUI terpadu. Jika submission
kampus secara eksplisit mewajibkan ekstensi `.mlapp`, layout dan callback
di `main_gui.m` dapat dipindahkan ke App Designer dengan struktur kontrol
yang sama; backend `.m` tidak perlu diubah.
