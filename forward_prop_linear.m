function [Z] = forward_prop_linear(A, W)
    Z = sigmoid(A * W, 0);
end

