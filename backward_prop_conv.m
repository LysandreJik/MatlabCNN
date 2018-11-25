function [dA_prev, dW, db] = backward_prop_conv(dZ, A_prev, W, stride, pad)
    
    [m, n_H_prev, n_W_prev, ~] = size(A_prev);
    [f, ~, n_C_prev, n_C] = size(W);
    [~, n_H, n_W, ~] = size(dZ);
    
    dA_prev = zeros(m, n_H_prev, n_W_prev, n_C_prev);
    dW = zeros(f, f, n_C_prev, n_C);
    db = zeros(1, 1, 1, n_C);
    
    A_prev_pad = zero_padding(A_prev, pad);
    dA_prev_pad = zero_padding(dA_prev, pad);
    
    for i=1:m
        a_prev_pad = zeros(size(A_prev_pad, 2), size(A_prev_pad, 3), size(A_prev_pad, 4));
        a_prev_pad(:, :, :) = A_prev_pad(i, :, :, :);
        da_prev_pad = zeros(size(dA_prev_pad, 2), size(dA_prev_pad, 3), size(dA_prev_pad, 4));
        da_prev_pad(:, :, :) = dA_prev_pad(i, :, :, :);
        
        for h=1:n_H-1
            for w=1:n_W-1
                for c=1:n_C
                    vert_start = h * stride;
                    vert_end = h * stride + f;
                    
                    horiz_start = w * stride;
                    horiz_end = w * stride + f;

                    a_slice = a_prev_pad(vert_start:vert_end-1, horiz_start:horiz_end-1, :);
                    w_slice = zeros(size(W, 1), size(W, 2), size(W, 3));
                    w_slice(:, :, :) = W(:, :, :, c);
                    da_prev_pad(vert_start:vert_end-1, horiz_start:horiz_end-1, :) = da_prev_pad(vert_start:vert_end-1, horiz_start:horiz_end-1, :) + w_slice * dZ(i, h, w, c);
                    dW(:, :, :, c) = dW(:, :, :, c) + a_slice * dZ(i, h, w, c);
                    db(:, :, :, c) = db(:, :, :, c) + dZ(i, h, w, c);
                end
            end
        end
        
        dA_prev(i, :, :, :) = da_prev_pad(pad:end-pad-1, pad:end-pad-1, :);
        
    end

end

