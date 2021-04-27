# Impulsive-Noise-Removal
This project implements the click-removal algorithm proposed in 

Oudre, Laurent. 2015. “Automatic Detection and Removal of Impulsive Noise in Audio Signals.” Image Processing On Line 5 (November): 267–81. https://doi.org/10.5201/ipol.2015.64.

Oudre, Laurent. 2018. “Interpolation of Missing Samples in Sound Signals Based on Autoregressive Modeling.” Image Processing On Line 8 (October): 329–44. https://doi.org/10.5201/ipol.2018.23.

The project uses MATLAB. 

`wholeWorkflow.m` implements the entire detection and interpolation process in one script. It reads an audio file and write the declicked signal into another one. 

To make experiments easier, it is functionized in `deClick.m` and called in the master experiment script `main.m`. 

The other scripts in the repository are for various experiments and visualizing the results. 


