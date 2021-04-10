% Real-world example, corresponding to the first part of 2.4.2
% plot part of a real audio sample and the detection function
clear; close
x = audioread('source_Muss_l.wav'); x = x(:,1);
% 2000 samples of audio file sampled at 44100
x = x(1001:3000);
subplot(2,1,1); plot(x)

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
subplot(2,1,2); plot(d)