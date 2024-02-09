clc;   
close all;
clear;

%% 2223 - Exercise 3 - Bag of visual words and SVM image classification
% Name: Martí Ejarque Galindo

%% Summary: write the code in MATLAB to do the following:
% - Obtain total samples per category and split dataset into train-test sets.
% - Create a bag of visual words with 100 or 500 words (try both values and compare the results).
% - Extract feature vectors from train-test sets using the bag of visual words and show a sample vector.
% - Create a SVM multi-class classifier from zero.
% - Evaulate SVM model using the test set and obtain the confusion matrix.

%% Dataset loading
close all;
data_path = fullfile('animals');
img_ds = imageDatastore(data_path, ...
    'IncludeSubfolders', true, ...
    'LabelSource', 'foldernames');

%% TEST 1 (1 point)
% Randomly, split dataset into train and test sets (splitEachLabel)
% Save the result in variables called img_ds_train and img_ds_test
% NOTE: 75% train test, 25% test set

[img_ds_train,img_ds_test] = splitEachLabel(img_ds,0.75,0.25);

%% TEST 2 (1 point)
% Prepare a bag of 100 visual words (bagOfFeatures). When you have
% completed the whole exercise, repeat with a bag of 500 words to compare
% the results. If you want, you can try other numbers of visual words.
% Save it in a variable called bag_w

bag_w = bagOfFeatures(img_ds_train, 'TreeProperties',[1 100]);
%bag_w = bagOfFeatures(img_ds_train, 'TreeProperties',[1 500]);

%% TEST 3 (1 point)
% Get feature vectors (word count) from train and test sets using 'bag_w' (encode)
% Save them in variables called feat_train and feat_test, respectively

feat_train = encode(bag_w, img_ds_train);
feat_test = encode(bag_w, img_ds_test);


%% TEST 4 (0.5 points)
% Display as a histogram the word count from 1st image from train set (bar)
figure(1);
bar(feat_train(1,:));
xlabel('Visual Words');
ylabel('Frequency');
title('Visual Word Occurrences in 1st Image of Train Set');

%% TEST 5 (1 point)
% Create a SVM model template with a Gaussian kernel (templateSVM)
% Save the template on a variable called svm_template

svm_template = templateSVM('KernelFunction', 'gaussian');

%% TEST 6 (2 points)
% Train the SVM model (fitcecoc) using the train features and its class labels and 
% also making use of the template created in the previous TEST.
% Save the model in a variable called model

model = fitcecoc(feat_train, img_ds_train.Labels, 'Learners', svm_template);

%% TEST 7 (1.5 points)
% Make a prediction using the feature vectors from test set (predict) and obtain prediction accuracy in %
% Save the results in variables called pred_Y and accuracy, respectively

pred_Y = predict(model, feat_test);
accuracy = sum(pred_Y == img_ds_test.Labels)/numel(img_ds_test.Labels) * 100;

%% TEST 8 (1.5 points)
% Obtain and display the confusion matrix from the result of the previous TEST (confusionchart)
figure(2);
confusionchart(img_ds_test.Labels, pred_Y, 'Title', 'Confusion Matrix');

%% TEST 9 (0.5 points)
% Create a new figure and display the first image in the test set, and put the classifier prediction as the title of the figure (title)
% NOTE: Access to the images in the test set using img_ds_test.Files
% NOTE 2: The predictions for the test set images are stored in 'Pred_Y', which is a categorical vector

img = imread(img_ds_test.Files{1});

pred = pred_Y(1);

figure(3);
imshow(img);
title(char(pred));
