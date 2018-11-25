function [dW] = backward_prop_linear(dY, Y_)
    dW = dY .* sigmoid(Y_, 1);
end

