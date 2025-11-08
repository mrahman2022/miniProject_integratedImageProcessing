%% Lab 6: Mini Project – Your Image Pipeline
% Student: Mahfuzur Rahaman
% Program: BSc IT
% Course: Mathematical Algorithms (DSP) — Image Processing Labs
% Goal: combine filtering, frequency, edges, and enhancement into a short pipeline
% Save this file as: Lab6_ImagePipeline.m

close all; clear; clc;

%% --- Setup: paths and output folder ---
% Use your image filename here (put the file in the same folder as this script)
userImageName = 'your_image.jpg';

outputDir = fullfile(pwd, 'figures_lab6');
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

%% --- 1) Load image (grayscale) with safe fallback ---
if exist(userImageName, 'file')
    I0 = imread(userImageName);
    fprintf('Using user image: %s\n', userImageName);
else
    warning('"%s" not found. Falling back to peppers.png or cameraman.tif.', userImageName);
    if exist('peppers.png','file')
        I0 = imread('peppers.png');
    else
        I0 = repmat(imread('cameraman.tif'),1,1,3);
    end
end

% Convert to grayscale double in [0,1]
if size(I0,3) == 3
    I = im2double(rgb2gray(I0));
else
    I = im2double(I0);
end

imwrite(im2uint8(I), fullfile(outputDir, 'lab6_original.png'));

%% --- 2) Pre-process: noise removal (median filter) ---
I_filt = medfilt2(I, [3 3]);                % removes impulse noise, preserves edges
imwrite(im2uint8(I_filt), fullfile(outputDir, 'lab6_denoised_med3.png'));

%% --- 3) Enhance contrast (linear contrast stretching) ---
% map [low, high] percentiles to [0 1] if you want adaptive stretch
low_in = 0.02; high_in = 0.98;              % you can tune
I_enh = imadjust(I_filt, [low_in high_in], [0 1]);
imwrite(im2uint8(I_enh), fullfile(outputDir, 'lab6_enhanced.png'));

%% --- 4) Extract features (Canny edges) ---
edges = edge(I_enh, 'Canny', [0.08 0.20]);  % thresholds in [0,1] — tune as needed
imwrite(edges, fullfile(outputDir, 'lab6_edges_canny.png'));

%% --- 5) Optional frequency-domain low-pass mask and result ---
% Compute centered FFT
F = fft2(I_enh);
Fshift = fftshift(F);
[M, N] = size(I_enh);

% Frequency grid (centered) matching fftshift layout
u = (-floor(N/2)):(ceil(N/2)-1);
v = (-floor(M/2)):(ceil(M/2)-1);
[U, V] = meshgrid(u, v);
D = sqrt(U.^2 + V.^2);

% Circular low-pass mask (tunable cutoff)
D0 = 60; % cutoff radius in frequency bins - change for more/less smoothing
H = double(D <= D0);

% Apply mask in frequency domain and invert
Gshift = Fshift .* H;
G = ifft2(ifftshift(Gshift));
I_lp = real(G);
I_lp = mat2gray(I_lp); % normalize to [0,1] for display/saving
imwrite(im2uint8(I_lp), fullfile(outputDir, 'lab6_freq_lp.png'));

%% --- 6) Compose montage for visualization and save ---
figure('Visible','off');
mont = montage({I, I_filt, I_enh, edges, I_lp}, 'Size', [1 5]);
title('Original | Denoised | Enhanced | Edges (Canny) | Frequency LP');
% Save the montage figure
saveas(gcf, fullfile(outputDir, 'lab6_montage.png'));
close(gcf);

%% --- 7) Short report printed to console (copy to README) ---
fprintf('\n=== Lab 6: Mini Project Report ===\n');
fprintf('Image used: %s\n', userImageName);
fprintf('Denoising: median 3x3 (preserves edges, removes impulsive noise)\n');
fprintf('Contrast: linear stretch using [%g, %g] quantiles -> [0,1]\n', low_in, high_in);
fprintf('Edge detection: Canny (thresholds [0.08 0.20])\n');
fprintf('Frequency LP: circular ideal low-pass with cutoff D0 = %d (in freq bins)\n', D0);
fprintf('Figures saved to: %s\n', outputDir);

%% --- 8) Short discussion (copy into lab report) ---
fprintf('\n--- Discussion notes (short) ---\n');
fprintf('1) Pre-processing (median) reduces impulse noise while preserving edges — a DSP low-pass-like local operation.\n');
fprintf('2) Contrast stretching is a linear amplitude remapping (gain + offset) that improves dynamic range visibility.\n');
fprintf('3) Edge extraction (Canny) is a gradient-based high-frequency detector: edges correspond to high-frequency content.\n');
fprintf('4) Frequency-domain low-pass suppresses high frequencies globally and yields smoother images; ideal circular LP can cause ringing (Gibbs) if hard cutoff is used.\n');

%% --- 9) Tips for improvements (for report) ---
fprintf('\n--- Improvements & limitations ---\n');
fprintf('- Use bilateral or non-local means for denoising to better preserve textures.\n');
fprintf('- Use Gaussian LP (in freq or spatially separable) instead of ideal mask to avoid ringing.\n');
fprintf('- Tune Canny thresholds or use edge linking/morphology to get cleaner segmentation.\n');
fprintf('- For segmentation, consider Otsu + morphological operations or watershed for object separation.\n');

% End of script
