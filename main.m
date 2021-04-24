% This script calls on the deClick function
% it runs for 170s for a 60s audio, still too slow
clear; close

IN_FILE = 'source_Muss_l.wav';
OUT_FILE = 'MussK2b40I1.wav';
ITER = 1;

[x,fs] = audioread(IN_FILE);
y = x;

for m=1:ITER
y = deClick(y, 2, 40, 100);
end

audiowrite(OUT_FILE, y, fs)

subplot(2,1,1);plot(x(:,1));ylim([-1,1]);
subplot(2,1,2);plot(y);ylim([-1,1])
