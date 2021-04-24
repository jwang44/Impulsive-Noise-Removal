% This script functionizes wholeWorkflow.m
% x -- audio signal, read from the audio file
% K -- threshold parameter, default to 2
% b -- fusion parameter, default to 20
% Nmax -- maximum length of a burst, default to 100
% clean -- 'clean' signal after click removal

function clean = deClick(x, K, b, Nmax)
% convert to mono
x = x(:,1);
p = 3*Nmax + 2; % AR order
Nw = 8*p;   % window length
Nh = Nw/4;  % hop size, 75% overlap

N = length(x);
% pad Nw zeros before and after signal samples
xPad = [zeros(Nw,1); x; zeros(Nw,1)];
% round up the number of frames
xRound = [xPad; zeros(((ceil((N+Nw)/Nh)*Nh-Nw)-N),1)];
% split signal into overlapping frames
Y = buffer(xRound,Nw,Nw-Nh, 'nodelay');

% buffer for output
output = zeros(size(xRound));
win = hamming(Nw)/(4*0.54);

% detect the locations of corrupted samples (T) for each frame
for m=1:size(Y,2)
    % get one frame
    frame = Y(:,m);
    % get AR parameters of each frame (Yule-walker)
    [A, e] = aryule(frame, p);
    % detection function
    d = filter(A, 1, frame);
    d(1:p) = 0;  % d is only defined for t>p
    d = abs(d);
    % threshold controlled by parameter K
    thre = K*sqrt(e);
    % locations of corrupted samples
    T = d>=thre;
    k = find(T);  % index of positive samples
    for n=1:length(k)-1
        if k(n+1)-k(n) <= b
            T(k(n):k(n+1)) = 1;
        end
    end
    % after detecting the locations T, interpolate the samples
    frame(T) = NaN;
    interp = fillgaps(frame, Nw, p);
    interpWin = interp.*win;
    
    % reconstruct the signal
    startIdx = (m-1)*Nh+1;
    stopIdx = (m-1)*Nh+Nw;
    output(startIdx:stopIdx) = output(startIdx:stopIdx)+interpWin;
end

% remove the padded samples
clean = output(Nw+1:end-((ceil((N+Nw)/Nh)*Nh)-N));

end