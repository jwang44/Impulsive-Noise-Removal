% Detect impulsive noise using direct thresholding 
% corresponding to 2.1 to 2.3 in the paper

% This script plots the signal, the signal with noise, the detection 
% function and the precision-recall curve

clear; close
s = audioread('acousticg.wav'); s = s(:,1);
% 2000 samples of audio file sampled at 44100
s = s(1:2000);
subplot(3,1,1); plot(s); xlabel('sample number'); ylabel('amplitude')
title('Clean signal')

% gaussian noise with a certain variance and length
variance = 10^-3;
Nmax = 50;
n = sqrt(variance)*randn(Nmax, 1);

% add the noise to the middle of the signal
x = s;
nOnset = round((length(s)-Nmax)/2);
x(nOnset:nOnset+Nmax-1) = x(nOnset:nOnset+Nmax-1)+n;
subplot(3,1,2); plot(x); xlabel('sample number'); ylabel('amplitude')
title('Clean signal with artificial noise in the middle')

% estimate AR parameters
p = 3*Nmax + 2;
[A, e] = aryule(x, p);  % 1,a1,a2...

% compute detection function d
% d(t) = 1*x(t)+a1*x(t-1)+a2*x(t-2)...+ap*x(t-p)
d = filter(A, 1, x);
d(1:p) = d(1:p)*0;  % d is only defined for t>p
d = abs(d);
subplot(3,1,3); plot(d); xlabel('sample number'); ylabel('amplitude')
title('Detection signal')

% detect impulsive noise with direct thresholding
K = 0:10^-4:12;
% K = 0:10^-2:12;
thresholds = K*sqrt(e); % e is estimated variance of excitation
ps = zeros(size(thresholds));
rs = zeros(size(thresholds));
i = zeros(size(x)); i(nOnset:nOnset+Nmax-1) = 1; % true noisy region (label)
for m=1:length(thresholds)
    thre = thresholds(m);
%     thre = thresholds(length(thresholds)-m+1);
    pos = d>=thre;
    neg = d<thre;
    tp = sum(pos&i);
    tn = sum(neg&(~i));
    fp = sum(pos&(~i));
    fn = sum(neg&i);
    precision = tp/(tp+fp);
    recall = tp/(tp+fn);
    ps(m) = precision;
    rs(m) = recall;
end

% plot the precision-recall curve
figure
plot(rs, ps); axis([0 1 0 1]); title('Precision-recall curve')
xlabel('recall'); ylabel('precision')

