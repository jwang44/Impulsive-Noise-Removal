% Whole workflow: deal with long real examples
% this script is functionized in deClick.m
clear; close
Nmax = 100; % in practice the maximum length of a burst is around 100
p = 3*Nmax + 2;
Nw = 8*p;   % window length
Nh = Nw/4;  % hop size, 75% overlap

% parameters to tune
K = 2;
b = 20;

[x,fs] = audioread('source_Dipper.wav'); x = x(:,1);
N = length(x);
% pad Nw zeros before and after signal samples
xPad = [zeros(Nw,1); x; zeros(Nw,1)];
% round up the number of frames
xRound = [xPad; zeros(((ceil((N+Nw)/Nh)*Nh-Nw)-N),1)];
% split signal into overlapping frames
Y = buffer(xRound,Nw,Nw-Nh, 'nodelay');
% buffer for output
result = zeros(size(Y));
output = zeros(size(xRound));
% win = hamming(Nw)/(4*0.54);

q = 1:Nw;
win = (0.54-0.46*cos(2*pi*(q'-1)/Nw))/(4*0.54);

% detect the locations of corrupted samples (T) for each frame
for m=1:size(Y,2)
    % get one frame
    frame = Y(:,m);
    % get AR parameters on each frame
    [A, e] = aryule(frame, p);
    d = filter(A, 1, frame);
    d(1:p) = 0;  % d is only defined for t>p
    d = abs(d);
    thre = K*sqrt(e);   % threshold
    T = d>=thre;   % T is locations of corrupted samples
    k = find(T);  % index of pos samples
    for n=1:length(k)-1
        if k(n+1)-k(n) <= b
            T(k(n):k(n+1)) = 1;
        end
    end
    % after detecting the locations T, we interpolate the samples
    frame(T) = NaN;
    interp = fillgaps(frame, Nw, p);
    interpWin = interp.*win;
    
    % reconstruct the signal
    startIdx = (m-1)*Nh+1;
    stopIdx = (m-1)*Nh+Nw;
    output(startIdx:stopIdx) = output(startIdx:stopIdx)+interpWin;    
    
end

% remove the padded samples
output = output(Nw+1:end-((ceil((N+Nw)/Nh)*Nh)-N));

% no need to normalize the output before writing to wav file
% because we perfectly reconstruct the signal
% output = output/max(abs(output));
audiowrite('Dipper.wav', output, fs)