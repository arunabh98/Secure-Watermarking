% Read the audio file.
[y,Fs] = audioread('iktara.wav');

% Calculate zero crossings.
M10 = movingmean(y,10,[],[]);
ZC = 0;
for i = 2:length(M10)
    if((M10(i-1)~=0) && (sign(M10(i-1))~=sign(M10(i))))
        ZC = ZC+1;
    end
end 

% Calculate the value b and choose the value n.
b = floor(0.5*length(y)/ZC);
n = 9;

L = 10;
% Assign watermark message.
w = [ones(1,L/2),-ones(1,L/2)];
w = w(randperm(length(w)));

% Set embedding strength.
S = mean(abs(dct(y)))*100;

embedded_signal = embed_watermark(y, n, b, S, w);

fc = 1000;
[j,k] = butter(6,fc/(Fs/2));
filtered_signal = filter(j,k,embedded_signal);

w_extracted = -1*extract_watermark(filtered_signal, n, b, S, L);

% Display error between extracted watermark and actual watermark.
disp(sum(w_extracted ~= w));