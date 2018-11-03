# Robust Audio Watermarking

We have implemented a robust watermarking algorithm which maintains high audio quality, while simultaneously, is highly robust to common digital signal
processing operations, including additive noise, sampling rate change, bit resolution
transformation, MP3 compression, and random cropping, especially low-pass filtering. 

We have achieved this by embedding the watermark into the maximal coefficient in discrete cosine transform domain of a moving average sequence using QIM. At the same time, we have also embedded a 
synchronization code to locate the
watermark and improve the accuracy of the detecting algorithm.

A presentation describing the details of our algorithm can be found over [here][1].

[1]: https://arunabh98.github.io/reports/audio_watermarking.pdf
