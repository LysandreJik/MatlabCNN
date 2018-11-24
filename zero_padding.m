function [X_pad] = zero_padding(X, pad)
    X_pad = zeros(size(X, 1), size(X, 2) + 2 * pad, size(X, 3) + 2 * pad, size(X, 4));
    for m=1:size(X, 1)
        for l=1:size(X, 4)
            X_pad(m, pad+1:end-pad, pad+1:end-pad, l) = X(m, :, :, l);
        end
    end
end

