function[dA_prev] = backward_prop_pooling(dA, A_prev, stride, f)
    [m, n_H, n_W, n_C] = size(dA);
    dA_prev = zeros(size(A_prev));
    for i=1:m
        for h=1:n_H-1
           for w=1:n_W-1
               for c=1:n_C
                   vert_start = h * stride;
                   vert_end = h * stride + f;
                   horiz_start = w * stride;
                   horiz_end = w * stride + f;
                   da = dA(i, h, w, c);
                   average = average_values(da, f, f);
                   dA_prev(i, vert_start:vert_end-1, horiz_start:horiz_end-1, c) = squeeze(dA_prev(i, vert_start:vert_end-1, horiz_start:horiz_end-1, c)) + average;
               end
           end
        end
    end
end

function [a] = average_values(dz, n_H, n_W)
    average = dz/(n_H * n_W);
    a = ones(n_H, n_W) * average;
end
