# Lab 6: Mini Project — Surfing Image Pipeline

**Student:** Mahfuzur Rahaman  
**Program:** BSc in Information Technology  
**Course:** Mathematical Algorithms (DSP) — Image Processing Labs  
**Lab No.:** 6 — Mini Project (surfing.jpg)

---

## Goal
Combine filtering, frequency analysis, edge detection and enhancement into a compact pipeline applied to `surfing.jpg` (action outdoor photo with waves and splash details).

---

## Pipeline (implemented in `Lab6_SurfingPipeline.m`)
1. **Load** `surfing.jpg` (falls back to container path if not found).  
2. **Denoise**: median 3×3 (`medfilt2`) — removes impulse noise and preserves edges; optional `imbilatfilt` applied if available.  
3. **Contrast enhancement**: percentile-based linear stretch using [2%,98%] to boost detail while avoiding clipping.  
4. **Edge extraction**: Canny (thresholds `[0.06 0.2]`, sigma=1) — captures surfboard, splashes, and wave textures.  
5. **Frequency low-pass**: Gaussian low-pass in frequency domain (sigma frequency = 30) to smooth large-scale variations (sky/water) with minimal ringing.  
6. **Save outputs** to `figures_lab6/` and write a short `lab6_report.txt`.

---

## Files produced (in `/figures_lab6`)
- `lab6_original_color.png` — original color image  
- `lab6_original_gray.png` — original grayscale  
- `lab6_denoised.png` — after median (+ optional bilateral)  
- `lab6_enhanced.png` — contrast-stretched result  
- `lab6_edges_canny.png` — Canny edge mask  
- `lab6_freq_gauss_lp.png` — frequency-domain Gaussian LP result  
- `lab6_freq_mask.png` — visualization of the Gaussian frequency mask  
- `lab6_montage.png` — combined montage of the main steps  
- `lab6_report.txt` — short pipeline report and metrics

---

## Observations & Notes
- **Edges** correspond to high-frequency content: splashes and board edges show up strongly in the Canny mask.  
- **Median filtering** preserved splash edges better than averaging would; bilateral (if available) further preserves texture.  
- **Percentile-based contrast stretch** improves visibility of both shadowed and bright regions (surfboard and waves).  
- **Gaussian LP in freq domain** smooths sky/water while avoiding severe ringing (because Gaussian is continuous).
