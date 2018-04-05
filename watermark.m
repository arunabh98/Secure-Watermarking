[y,Fs] = audioread('gaana.wav');
y = y(1:1000000);
M10 = movingmean(y,10,[],[]);
ZC = 0;
for i = 2:length(M10)
    if((M10(i-1)~=0) && (sign(M10(i-1))~=sign(M10(i))))
        ZC = ZC+1;
    end
end     
b = floor(0.5*length(y)/ZC);
n = 12;
M = movingmean(y,b,[],[]);
NoF = floor(length(M)/(n*b));
L = 10;
w = zeros(1, L);
x = y;
Z = zeros(size(y));
k = 1;
S = mean(abs(dct(y)))*10;
p = floor(NoF/length(w));
W = zeros(p, L);
for q = 1:p
    for k = 1:L
        i = (q-1)*length(w)+k;
        T = dct(M((i-1)*(n*b)+b+1:i*(n*b)));
        [~,j] = max(abs(T));
        t = T(j);
        if t - (floor(t/S)*S) >= S/2
            W(q, k) = 1;
        else
            W(q, k) = -1;
        end
    end
end

sum_w = sum(W);
sum_w(sum_w >= 0) = 1;
sum_w(sum_w < 0) = -1;
