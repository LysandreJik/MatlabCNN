function [y] = sigmoid(x, deriv)
    if deriv == 1
        y = sigmoid(x, 0) .* (1 - sigmoid(x, 0));
    else
        y = 1./(1+exp(-x));
    end
end

