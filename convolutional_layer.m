function [Z] = convolutional_layer(a_slice_prev ,W, b)
    s = a_slice_prev .* W;
    Z = sum(s, 'all');
    Z = Z + b;
end

