% This script plots audio files, 
% to compare the results using different parameters
clear; close

addpath('output audio');
a = audioread('source_Muss_l.wav');
b = audioread('MussK2b1I1.wav');
c = audioread('MussK2b20I1.wav');
d = audioread('MussK2b40I1.wav');

subplot(4,1,1); plot(a(:,1))
title('Unprocessed corrupted signal')
subplot(4,1,2); plot(b)
title('De-clicked (b=1)')
subplot(4,1,3); plot(c)
title('De-clicked (b=20)')
subplot(4,1,4); plot(d)
title('De-clicked (b=40)')