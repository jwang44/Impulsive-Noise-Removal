% Variant2: for multiple bursts
% find all samples T exceeding the threshold
% for any two samples in T, if abs(t2-t1)<b, we determine all samples in
% between belong to noise
% corresponding to 2.4.2 in the paper
clear; close
x = audioread('source_Muss_l.wav'); x = x(:,1);
% 2000 samples of audio file sampled at 44100
x = x(8001:10000);
subplot(2,1,1); plot(x); xlabel('sample number'); ylabel('amplitude')
title('Corrupted signal')

% assume maximum length of a burst
Nmax = 50;
% estimate AR parameters
p = 3*Nmax + 2;
[A, e] = aryule(x, p);  % 1,a1,a2...

% compute detection function d
% d(t) = 1*x(t)+a1*x(t-1)+a2*x(t-2)...+ap*x(t-p)
d = filter(A, 1, x);
d(1:p) = d(1:p)*0;  % d is only defined for t>p
d = abs(d);

% parameters to tune
b1 = 1; b2 = 30;
K1 = 1; K2 = 2; K3 = 3;

thre1 = K1*sqrt(e); % e is estimated variance of excitation
thre2 = K2*sqrt(e); 
thre3 = K3*sqrt(e); 

subplot(2,1,2); plot(d); xlabel('sample number'); ylabel('amplitude')
title('Detection signal with thresholds')

r = yline(thre1, 'r--');
g = yline(thre2, 'g--');
b = yline(thre3, 'b--');

r.LineWidth = 1.5;
g.LineWidth = 1.5;
b.LineWidth = 1.5;

figure
pos1 = thresholding(d, thre1, b1);
pos2 = thresholding(d, thre2, b1);
pos3 = thresholding(d, thre3, b1);
subplot(3,2,1); plot(pos1); title('K=1  b=1'); ylim([-0.1, 1.1])
subplot(3,2,3); plot(pos2); title('K=2  b=1'); ylim([-0.1, 1.1])
subplot(3,2,5); plot(pos3); title('K=3  b=1'); ylim([-0.1, 1.1])

pos4 = thresholding(d, thre1, b2);
pos5 = thresholding(d, thre2, b2);
pos6 = thresholding(d, thre3, b2);
subplot(3,2,2); plot(pos4); title('K=1  b=30'); ylim([-0.1, 1.1])
subplot(3,2,4); plot(pos5); title('K=2  b=30'); ylim([-0.1, 1.1])
subplot(3,2,6); plot(pos6); title('K=3  b=30'); ylim([-0.1, 1.1])