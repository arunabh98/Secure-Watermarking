function w_extracted = extract_watermark(y, n, b, S, L)
    % Start the watermark extraction process.
    M = movingmean(y,b,[],[]);
    
     % Calculate the number of frames and choose the length of the watermark
    % message.
    NoF = floor(length(M)/(n*b));
    p = floor(NoF/L);

    % Use the parameters - watermark message length, embedding strength as
    % above.
    W = zeros(p, L);
    for q = 1:p
        for k = 1:L
            i = (q-1)*L+k;
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
end