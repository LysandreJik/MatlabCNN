%% Convolutional neural nets

% Fetch images from dataset
images = fetch_images();
n_images = size(images, 1);

% Assign images to the A matrix (Mx50x50x3)
A_prev = images;
Y = [0; 1; 1];

% Initialize the weight matrix with random values
% Number of filters
n_filters = 10;
% Weight matrix
W = rand(5, 5, 3, n_filters);
% bias matrix
b = ones(1, 1, 1, n_filters);

pad = 1;
stride = 5;

learning_rate = 0.01;

first_layer_size = 250;
second_layer_size = 50;

% First weight matrix
W0_1 = rand(first_layer_size, second_layer_size);

% Second weight matrix
W1_2 = rand(second_layer_size, 1);

% Total number of iterations
iterations = 600;

% Error vector for plotting
errors = zeros(iterations, 1);


%% Fit

for ite=1:iterations
    % Pass the images through the first convolutional layer (Mx50x50x3) => (Mx10x10x10)
    [convoluted_images, conv1_A_prev, conv1_W, conv1_b, conv1_stride, conv1_pad] = forward_prop_conv(A_prev, W, b, stride, pad);

    % Average pooling (Mx10x10x10) => (Mx5x5x10)
    [pooled_images, m_pool, n_H_pool, n_W_pool, n_C_pool] = pooling(convoluted_images, 2, 2);

    % Flatten (Mx5x5x10) => (Mx250)
    flattened = zeros(size(pooled_images, 1), size(pooled_images, 2)*size(pooled_images, 3)*size(pooled_images, 4));

    for i=1:size(pooled_images, 1)
        flattened(i, :) = reshape(squeeze(pooled_images(i, :, :, :)), [size(pooled_images, 2)*size(pooled_images, 3)*size(pooled_images, 4), 1]);
    end

    % Feed forward neural networks (Mx250 => Mx50 => Mx1)
    layer_0 = flattened;
    % First layer (Mx250 => Mx50)
    layer_1 = sigmoid(layer_0 * W0_1, 0);
    % Second layer (Mx50 => Mx1)
    layer_2 = sigmoid(layer_1 * W1_2, 0);
    
    % Calculating the error of the first two layers and updating the
    % weights
    layer_2_error = Y - layer_2;
    layer_2_delta = layer_2_error .* sigmoid(layer_2, 1);
    
    layer_1_error = layer_2_delta * W1_2';
    layer_1_delta = layer_1_error .* sigmoid(layer_1, 1);
    
    W0_1 = W0_1 + flattened' * layer_1_delta;
    W1_2 = W1_2 + layer_1' * layer_2_delta;
    
    % Calculating the error of the weights between the pooling layer and
    % the dense layer
    layer_0_error = layer_1_delta * W0_1';
    layer_0_delta = layer_0_error .* sigmoid(layer_0, 1);

    % Reshaping the pooling error (Mx50 => Mx250)
    unflattened_delta = reshape(layer_0_delta, [3, size(pooled_images, 2), size(pooled_images, 3), size(pooled_images, 4)]);
    
    % Backpropagate the pooling error
    pooling_error = backward_prop_pooling(unflattened_delta, convoluted_images, 2, 2);
    
    [dA_prev, dW, db] = backward_prop_conv(pooling_error, A_prev, W, stride, pad);
    
    W = W + dW;
    b = b + db;
    
    if(mod(ite, 100) == 0)
        disp(mean(abs(layer_2_error)));
    end
    errors(ite, 1) = abs(sum(layer_1_error, 'all'));
    errors(ite, 2) = abs(sum(layer_2_error, 'all'));
    
end
plot(errors)
