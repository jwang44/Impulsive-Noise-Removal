% Variant2: for multiple bursts
% find all samples T exceeding the threshold
% for any two samples in T, if abs(t2-t1)<b, we determine all samples in
% between belong to noise
% corresponding to 2.4.2 in the paper
clear; close
x = audioread('source_Muss_l.wav'); x = x(:,1);
% 2000 samples of audio file sampled at 44100
x = x(3001:5000);
subplot(3,1,1); plot(x)

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
subplot(3,1,2); plot(d)

% parameters to tune
b1 = 1; b2 = 20;
K1 = 1; K2 = 1.5; K3 = 3;

thre1 = K1*sqrt(e); % e is estimated variance of excitation
thre2 = K2*sqrt(e); 
thre3 = K3*sqrt(e); 

pos = d>=thre1;
k = find(pos);  % index of pos samples
for n=1:length(k)-1
    if k(n+1)-k(n) <= b2
        pos(k(n):k(n+1)) = 1;
    end
end
neg = ones(size(d)) - pos;
subplot(3,1,3); plot(d)
yline(thre1, 'r--')
yline(thre2, 'g--')
yline(thre3, 'b--')

