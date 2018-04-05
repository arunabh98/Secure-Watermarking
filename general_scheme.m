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

% % High-pass filter
% Fstop = 350;
% Fpass = 400;
% Astop = 65;
% Apass = 0.5;
% d = designfilt('highpassfir','StopbandFrequency',Fstop, ...
%   'PassbandFrequency',Fpass,'StopbandAttenuation',Astop, ...
%   'PassbandRipple',Apass,'SampleRate',Fs,'DesignMethod','equiripple');
% D = mean(grpdelay(d)); % filter delay in samples
% filtered_signal = filter(d,[embedded_signal; zeros(D,1)]);
% filtered_signal = filtered_signal(D+1:end);

% % Low-pass filter.
% Fpass = 500;
% Fstop = 600;
% Apass = 1;
% Astop = 65;
% 
% d = designfilt('lowpassfir', ...
%   'PassbandFrequency',Fpass,'StopbandFrequency',Fstop, ...
%   'PassbandRipple',Apass,'StopbandAttenuation',Astop, ...
%   'DesignMethod','equiripple','SampleRate',Fs);
% D = mean(grpdelay(d)); % filter delay in samples
% filtered_signal = filter(d,[embedded_signal; zeros(D,1)]);
% filtered_signal = filtered_signal(D+1:end);


w_extracted = extract_watermark(filtered_signal, n, b, S, L);

% Display error between extracted watermark and actual watermark.
disp(sum(w_extracted ~= w));