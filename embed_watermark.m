function x = embed_watermark(y, n, b, S, w)
    % Calculate MAS.
    M = movingmean(y,b,[],[]);

    % Calculate the number of frames and choose the length of the watermark
    % message.
    NoF = floor(length(M)/(n*b));

    % Start embedding the watermark code into the audio file.
    x = y;
    Z = zeros(size(y));
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
end
