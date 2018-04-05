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
n = 15;

% Calculate MAS.
M = movingmean(y,b,[],[]);

% Calculate the number of frames and choose the length of the watermark
% message.
NoF = floor(length(M)/(n*b));

L = 10;
% Assign watermark message.
w = [ones(1,L/2),-ones(1,L/2)];
w = w(randperm(length(w)));

% Set embedding strength.
S = mean(abs(dct(y)))*10;

% Start embedding the watermark code into the audio file.
x = y;
Z = zeros(size(y));
k = 1;
p = floor(NoF/length(w));

for q = 1:p
    for k = 1:length(w)
        i = (q-1)*length(w)+k;
        T = dct(M((i-1)*(n*b)+b+1:i*(n*b)));
        [~,j] = max(abs(T));
        t = T(j);
        if(w(k)==1)
            T(j) = round((t+S/4)/S)*S-S/4;
        else
            T(j) = round((t+3*S/4)/S)*S-3*S/4;
        end
%         if(abs(T(j))>S)
%             T(abs(T)>0.9*abs(T(j))) = abs(T(j))-S/8;
%         else
%             T(abs(T)>0.9*abs(T(j))) = 0.8*S;
%         end
        N = idct(T);
        v = [zeros(b,1);N-M((i-1)*(n*b)+b+1:i*(n*b))];
        z = zeros(n*b+b-1,1);
        z(n*b:n*b+b-1) = v(n*b);
        for r = 1:n*b-1
            z(r) = b*(v(r)-v(r+1)) + z(r+b);
        end
        x((i-1)*n*b+b+1:i*(n*b)+b-1) = y((i-1)*n*b+b+1:i*(n*b)+b-1) + z(b+1:n*b+b-1);
        Z((i-1)*n*b+b+1:i*(n*b)+b-1) = z(b+1:n*b+b-1);
    end
end
x = x/max(abs(x));

% Write the watermarked audio.
audiowrite('gaana.wav',x,Fs);

% Load the watermarked audio.
[y,Fs] = audioread('gaana.wav');

% Start the watermark extraction process.
M = movingmean(y,b,[],[]);

% Use the parameters - watermark message length, embedding strength as
% above.
W = zeros(p, L);
for q = 1:p
    for k = 1:L
        i = (q-1)*length(w)+k;
        T = dct(M((i-1)*(n*b)+b+1:i*(n*b)));
        [~,j] = max(abs(T));
        t = T(j);
        if t - (floor(t/S)*S) >= (S/2)
            W(q, k) = 1;
        else
            W(q, k) = -1;
        end
    end
end
w_extracted = sum(W);
w_extracted(w_extracted >= 0) = 1;
w_extracted(w_extracted < 0) = -1;

% Display error between extracted watermark and actual watermark.
disp(sum(w_extracted ~= w));




