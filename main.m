% This script calls deClick function
% it runs for 170s for a 60s audio, still too slow
clear; close

IN_FILE = 'source_Dipper.wav';
OUT_FILE = 'Dipper.wav';
ITER = 1;

[x,fs] = audioread(IN_FILE);

for m=1:ITER
y = deClick(x, 2, 20, 100);
end

audiowrite(OUT_FILE, y, fs)

subplot(2,1,1);plot(x);ylim([-1,1]);
subplot(2,1,2);plot(y);ylim([-1,1])
