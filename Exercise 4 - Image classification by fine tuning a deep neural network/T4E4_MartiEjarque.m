clc;   
close all;
clear;

%% 2223 - Exercise 4 - Fine tuning of a Deep Neural Network
% Name: Martí Ejarque Galindo

%% Summary: write the code in MATLAB to do the following:
% - Obtain total samples per category and split dataset into train-test sets.
% - Load the pretrained alexnet Deep Network, determine its needed input size and create a layerGraph from the network.
% - Update train and test sets to modify image dimensions to the input size.
% - Create a new fully connected layer and replace it in the same place of the last existing fully connected layer of the neural network.
% - Create a new classification layer and replace it in the same place of the classification layer of the neural network.
% - Train the fine-tuned network.
% - Make a classification using the test set and create the confusion matrix.

% NOTE: Follow matlab's guide on Neural Networks fine tuning

%% Dataset loading
close all;
data_path = fullfile('animals');
img_ds = imageDatastore(data_path, ...
    'IncludeSubfolders', true, ...
    'LabelSource', 'foldernames');

%% TEST 1 (0.5 points)
% Randomly, split dataset into train and test sets (splitEachLabel)
% Save the result in variables called img_ds_train and img_train_test
% NOTE: 75% train test, 25% test set

[img_ds_train,img_ds_test] = splitEachLabel(img_ds,0.75,'randomized');

%% TEST 2 (1 point)
% Load the pretrained alexnet Deep Network, determine its needed input size and create a layerGraph from the network.
% Save the values in variables called net, input_size and lgraph, respectively
net = alexnet;
%deepNetworkDesigner(net);
input_size = net.Layers(1).InputSize;
lgraph = layerGraph(net);

%% TEST 3 (1 point)
% Update train and test sets to modify image dimensions to the input size (augmentedImageDatastore)
% Save the result in variables called img_ds_train_aug and img_train_test_aug
% NOTE: You could need to preprocess the color for the model to work
pixelRange = [-30 30];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange);

img_ds_train_aug = augmentedImageDatastore(input_size(1:2),img_ds_train,'ColorPreprocessing','gray2rgb', 'DataAugmentation',imageAugmenter);%'ColorPreprocessing','gray2rgb'
img_ds_test_aug = augmentedImageDatastore(input_size(1:2),img_ds_test,'ColorPreprocessing','gray2rgb','DataAugmentation',imageAugmenter);%'ColorPreprocessing','gray2rgb'



 %% TEST 4 (2 points)
% Create a new fully connected layer (fullyConnectedLayer) with the same number of classes as outputs the model should have given the images, and a
% WeightLearnRateFactor and BiasLearnRateFactor of at least 10. Then, replace it in the same place of the last existing fully connected layer of the
% neural network (replaceLayer).
% NOTE: The higher the WeightLearnRateFactor and BiasLearnRateFactor, the faster the model will train, but the less accuracy it will have

numClasses = numel(categories(img_ds_train.Labels));
fcLayer = fullyConnectedLayer(numClasses, 'WeightLearnRateFactor', 10, 'BiasLearnRateFactor', 10);
lgraph = replaceLayer(lgraph, 'fc8', fcLayer);

%% TEST 5 (2 points)
% Create a new classification layer (classificationLayer) and replace it in the same place of the classification layer of the neural network (replaceLayer).

classificationLayer = classificationLayer();
lgraph = replaceLayer(lgraph, 'output', classificationLayer);


%% TEST 6 (2 points)
% Train the fine-tuned network (trainNetwork) with the specified options shown in the guide but changing MiniBatchSize to 10, MaxEpochs to 5 and
% changing ValidationData to the augmented test images.
% Save the model in a variable called model

options = trainingOptions('sgdm', ...
    'MiniBatchSize',10, ...
    'MaxEpochs',5, ...
    'InitialLearnRate',1e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',img_ds_test_aug, ...
    'ValidationFrequency',3, ...
    'Verbose',false, ...
    'Plots','training-progress');

model = trainNetwork(img_ds_train_aug, lgraph, options);


%% TEST 7 (1 point)
% Make a classification using the test set (classify)
% Obtain prediction accuracy in %
% Save the results in variables called Y_pred and accuracy respectively

Y_pred = classify(model, img_ds_test_aug);
accuracy = mean(Y_pred == img_ds_test.Labels) * 100;


%% TEST 8 (0.5 points)
% Obtain and display the confusion matrix from the result of the previous TEST (confusionchart)

figure;
confusionchart(img_ds_test.Labels, Y_pred);
