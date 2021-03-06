function [net] = multitasknn_mnist_init_net(varargin)

rng('default');
rng(0) ;

f=1/100 ;
net.layers = {} ;
net.layers{end+1} = struct(...
    'name', 'input', ...
    'bottom', 'data', ...
    'top', {{'input', 'label1', 'label2'}}, ...
    'type', 'data' ...
    ) ;
% 28 * 28 * 1
net.layers{end+1} = struct(...
    'name', 'conv1', ...
    'bottom', 'input', ...
    'top', 'conv1', ...
    'type', 'conv', ...
    'weights', {{f*randn(5,5,1,20, 'single'), zeros(1, 20, 'single')}}, ...
    'stride', 1, ...
    'pad', 0) ;
% 24 * 24 * 20
net.layers{end+1} = struct(...
    'name', 'conv2', ...
    'bottom', 'conv1', ...
    'top', 'conv2', ...
    'type', 'conv', ...
    'weights', {{f*randn(3,3,20,20, 'single'),zeros(1,20,'single')}}, ...
    'stride', 1, ...
    'pad', 1) ;
% 24 * 24 * 20
net.layers{end+1} = struct(...
    'name', 'relu1', ...
    'bottom', 'conv2', ...
    'top', 'relu1', ...
    'type', 'relu'...
    ) ;
% 24 * 24 * 20
net.layers{end+1} = struct(...
    'name', 'pool2', ...
    'bottom', 'relu1', ...
    'top', 'pool2', ...
    'type', 'pool', ...
    'method', 'max', ...
    'pool', [2 2], ...
    'stride', 1, ...
    'pad', [1,0,1,0]) ;
% 24 * 24 * 20
net.layers{end+1} = struct(...
    'name', 'conv3', ...
    'bottom', 'conv1', ...
    'top', 'conv3', ...
    'type', 'conv', ...
    'weights', {{f*randn(5,5,20,30, 'single'),zeros(1,30,'single')}}, ...
    'stride', 1, ...
    'pad', 2) ;
% 24 * 24 * 30
net.layers{end+1} = struct(...
    'name', 'conv5', ...
    'bottom', 'conv1', ...
    'top', 'conv5', ...
    'type', 'conv', ...
    'weights', {{f*randn(5,5,20,10, 'single'),zeros(1,10,'single')}}, ...
    'stride', 1, ...
    'pad', 2) ;
% 24 * 24 * 30
net.layers{end+1} = struct(...
    'name', 'concat1', ...
    'bottom', {{'pool2', 'conv3', 'conv5'}}, ...
    'top', 'concat1', ...
    'type', 'concat' ...
    ) ;
net.layers{end+1} = struct(...
    'name', 'pool1', ...
    'bottom', 'concat1', ...
    'top', 'pool1', ...
    'type', 'pool', ...
    'method', 'max', ...
    'pool', [2 2], ...
    'stride', 2, ...
    'pad', 0) ;
net.layers{end+1} = struct(...
    'name', 'conv4', ...
    'bottom', 'pool1', ...
    'top', 'conv4', ...
    'type', 'conv', ...
    'weights', {{f*randn(4,4,60,500, 'single'),  zeros(1,500,'single')}}, ...
    'stride', 1, ...
    'pad', 0) ;
net.layers{end+1} = struct(...
    'name', 'relu2', ...
    'bottom', 'conv4', ...
    'top', 'relu2', ...
    'type', 'relu'...
    ) ;
net.layers{end+1} = struct(...
    'name', 'fc1', ...
    'bottom', 'relu2', ...
    'top', 'fc1', ...
    'type', 'conv', ...
    'weights', {{f*randn(9,9,500,10, 'single'), zeros(1,10,'single')}}, ...
    'stride', 1, ...
    'pad', 0) ;
net.layers{end+1} = struct(...
    'name', 'loss1', ...
    'bottom', {{'fc1', 'label1'}}, ...
    'top', 'loss1', ...
    'type', 'softmaxloss') ;
net.layers{end+1} = struct(...
    'name', 'fc2', ...
    'bottom', 'relu2', ...
    'top', 'fc2', ...
    'type', 'conv', ...
    'weights', {{f*randn(9,9,500,10, 'single'), zeros(1,10,'single')}}, ...
    'stride', 1, ...
    'pad', 0) ;
net.layers{end+1} = struct(...
    'name', 'loss2', ...
    'bottom', {{'fc2', 'label2'}}, ...
    'top', 'loss2', ...
    'type', 'softmaxloss') ;

end