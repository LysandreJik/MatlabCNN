function [A, m, n_H, n_W, n_C] = pooling(A_prev, stride, kernel_size)
    [m, n_H_prev, n_W_prev, n_C] = size(A_prev);
    
    n_H = floor(1 + (n_H_prev - kernel_size) / stride);
    n_W = floor(1 + (n_W_prev - kernel_size) / stride);
    
    A = zeros(m, n_H, n_W, n_C);
    
    disp(n_H);
    disp(n_W);
    
    averaging_filter = ones(kernel_size);
    
    for i=1:m
        for l=1:n_C
            a_prev = zeros(n_H_prev, n_W_prev);
            a_prev(:, :) = A_prev(i, :, :, l);
            A_ = conv2(a_prev, averaging_filter, 'valid');
            A(i, :, :, l) = A_(1:stride:end, 1:stride:end);
        end
    end
end

