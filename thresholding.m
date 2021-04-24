% helper function that imposes the threshold on the detection function
function pos = thresholding(d, thre, b)
pos = d>=thre;
k = find(pos);  % index of pos samples
for n=1:length(k)-1
    if k(n+1)-k(n) <= b
        pos(k(n):k(n+1)) = 1;
    end
end
end