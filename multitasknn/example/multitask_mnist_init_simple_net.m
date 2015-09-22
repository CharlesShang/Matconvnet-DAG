function net = multitask_mnist_init_simple_net(varargin)
% CNN_MNIST_LENET Initialize a CNN similar for MNIST
opts.useBnorm = true ;
opts = vl_argparse(opts, varargin) ;

rng('default');
rng(0) ;

f=1/100 ;
net.layers = {} ;
net.layers{end+1} = struct(...
    'name', 'data', ...
    'bottom', 'data', ...
    'top', {{'input', 'label1'}}, ...
    'type', 'data' ...
    ) ;
net.layers{end+1} = struct('type', 'conv', ...
    'name', 'covn1', ...
    'bottom', 'input',...
    'top', 'conv1', ...
    'weights', {{f*randn(5,5,1,20, 'single'), zeros(1, 20, 'single')}}, ...
    'stride', 1, ...
    'pad', 0) ;
net.layers{end+1} = struct('type', 'pool', ...
    'name', 'pool1', ...
    'bottom', 'conv1',...
    'top', 'pool1', ...
    'method', 'max', ...
    'pool', [2 2], ...
    'stride', 2, ...
    'pad', 0) ;
net.layers{end+1} = struct('type', 'conv', ...
    'name', 'covn2', ...
    'bottom', 'pool1',...
    'top', 'conv2', ...
    'weights', {{f*randn(5,5,20,50, 'single'),zeros(1,50,'single')}}, ...
    'stride', 1, ...
    'pad', 0) ;
net.layers{end+1} = struct('type', 'pool', ...
    'name', 'pool2', ...
    'bottom', 'conv2',...
    'top', 'pool2', ...
    'method', 'max', ...
    'pool', [2 2], ...
    'stride', 2, ...
    'pad', 0) ;
net.layers{end+1} = struct('type', 'conv', ...
    'name', 'covn3', ...
    'bottom', 'pool2',...
    'top', 'conv3', ...
    'weights', {{f*randn(4,4,50,500, 'single'),  zeros(1,500,'single')}}, ...
    'stride', 1, ...
    'pad', 0) ;
net.layers{end+1} = struct('type', 'relu', ...
        'name', 'relu1', ...
    'bottom', 'conv3',...
    'top', 'relu1'...
    ) ;
net.layers{end+1} = struct('type', 'conv', ...
    'name', 'covn4', ...
    'bottom', 'relu1',...
    'top', 'conv4', ...
    'weights', {{f*randn(1,1,500,10, 'single'), zeros(1,10,'single')}}, ...
    'stride', 1, ...
    'pad', 0) ;
net.layers{end+1} = struct('type', 'softmaxloss', ...
        'name', 'loss1', ...
    'bottom', {{'conv4', 'label1'}},...
    'top', 'loss1') ;

% optionally switch to batch normalization


% --------------------------------------------------------------------
function net = insertBnorm(net, l)
% --------------------------------------------------------------------
assert(isfield(net.layers{l}, 'weights'));
ndim = size(net.layers{l}.weights{1}, 4);
layer = struct('type', 'bnorm', ...
    'weights', {{ones(ndim, 1, 'single'), zeros(ndim, 1, 'single')}}, ...
    'learningRate', [1 1], ...
    'weightDecay', [0 0]) ;
net.layers{l}.biases = [] ;
net.layers = horzcat(net.layers(1:l), layer, net.layers(l+1:end)) ;
