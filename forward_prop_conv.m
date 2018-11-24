function [Z, A_prev, W, b, stride, pad] = forward_prop_conv(A_prev, W, b, stride, pad)
    [m, n_H_prev, n_W_prev, n_C_prev] = size(A_prev);
    [f, ~, ~, n_C] = size(W);
    
    n_H = floor((n_H_prev + 2*pad - f)/stride) + 1;
    n_W = floor((n_W_prev + 2*pad - f)/stride) + 1;
    
    Z = zeros(m, n_H, n_W, n_C);
    
    size(Z)
    
    for i=1:2
       for c=1:n_C
           convolution_filter = ones(n_H, n_W) * b(1, 1, 1, c);
           for l=1:n_C_prev
               a = zeros(size(A_prev, 2) + 2*pad, size(A_prev, 3) + 2*pad);
               a(:, :) = zero_padding(A_prev(i, :, :, l), pad);
               convoluted = conv2(a, W(:, :, l, c), 'valid');
               convoluted = convoluted(1:stride:end, 1:stride:end);
               convolution_filter = convolution_filter + convoluted;
           end           
           Z(i, :, :, c) = convolution_filter;
            figure
            imshow(uint8(convolution_filter), [])
       end
    end
end

