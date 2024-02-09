clc;   
close all;
clear;

%% 2223 - Exercise 2 - Local features extraction and features matching
% Name: Martí Ejarque Galindo

%% Summary: write the code in MATLAB to do the following:
% - Detect HARRIS points from a set of images.
% - Extract HOG features from previous points.
% - Classify images using features matching and display the relationship between features.

% NOTE: The goal of the exercise is to prove you understand the concept
% that is being worked in the exercise, as the algorithms and images are prone
% to have mistakes.

% NOTE: However, try to get the best result. The more you work, the higher
% mark you will get.

%% TEST 1 (0.5 points)
% Read the images "Kermit_train.jpg" and "Multipla_train.jpg", convert them to grayscale and display them.
% Store the images in variables called kermit_train and multipla_train, respectively
kermit_train = rgb2gray(imread("T4E2_Images/Kermit_train.jpg"));
multipla_train = rgb2gray(imread("T4E2_Images/Multipla_train.jpg"));

reSize = size(kermit_train);
multipla_train = imresize(multipla_train,reSize);

figure;
subplot(2,2,1);imshow(kermit_train);title('Kermit Train');
subplot(2,2,2);imshow(multipla_train);title('Multipla Train');

%% TEST 2 (1 point)
% Detect the points in the images using the HARRIS point detector (detectHARRISFeatures.m)
% Store the valies in variables called points_kermit_train and points_multipla_train, respectively
ROIx = (size(kermit_train,2)*2)/3;
ROIy = (size(kermit_train,1)*2)/3;
points_kermit_train = detectHarrisFeatures(kermit_train,'MinQuality',0.0003,'ROI',[1 1 ROIx ROIy]);
points_multipla_train =  detectHarrisFeatures(multipla_train, 'MinQuality',0.01);


%% TEST 3 (1 point)
% Extract HOG features of both images (extractHOGFeatures.m) and display,
% in a single figure, both images features.
% Store the features in variables called feat_kermit_train and feat_multipla_train, respectively
[feat_kermit_train,valid_pointsTrainK,hogVisualizationK] = extractHOGFeatures(kermit_train,points_kermit_train);
[feat_multipla_train,valid_pointsTrainM,hogVisualizationM] = extractHOGFeatures(multipla_train,points_multipla_train);

subplot(2,2,3);
imshow(kermit_train); 
hold on;
plot(hogVisualizationK);title('Kermit Features Train');
hold off;
subplot(2,2,4);
imshow(multipla_train); 
hold on;
plot(hogVisualizationM);title('Multipla Features Train');
hold off;

%% TEST 4 (1.5 point)
% Repeat the all the previous Tests with Kermit_test.png and Multipla_test.png
% NOTE: Tune params on corner detection to get more/less corners and get a balance
kermit_test = rgb2gray(imread("T4E2_Images/Kermit_test.jpg"));
multipla_test = rgb2gray(imread("T4E2_Images/Multipla_test.jpg"));

reSize = size(kermit_train);
kermit_test = imresize(kermit_test,reSize);
multipla_test = imresize(multipla_test,reSize);

ROIx = size(kermit_test,2);
ROIy = size(kermit_test,1)-108;

figure;
subplot(2,2,1);imshow(kermit_test);title('Kermit Test');
subplot(2,2,2);imshow(multipla_test);title('Multipla Test');

points_kermit_test = detectHarrisFeatures(kermit_test,'MinQuality',0.0001);
points_multipla_test =  detectHarrisFeatures(multipla_test,'MinQuality',0.01,'ROI',[1 108  ROIx ROIy]);

[feat_kermit_test,valid_pointsTestK,hogVisualizationK]= extractHOGFeatures(kermit_test,points_kermit_test);
[feat_multipla_test,valid_pointsTestM,hogVisualizationM]= extractHOGFeatures(multipla_test,points_multipla_test);


subplot(2,2,3);
imshow(kermit_test); 
hold on;
plot(hogVisualizationK);title('Kermit Features Test');
hold off;
subplot(2,2,4);
imshow(multipla_test); 
hold on;
plot(hogVisualizationM);title('Multipla Features Test');
hold off;

%% TEST 5 (1.5 point)
% Perfom features matching (matchFeatures.m) from kermit_test to kermit_train and multipla_train 
% and classify kermit_test as 'kermit' or 'multipla' depending on how many matches were found.
% Store the classification label in a variable called pred_kermit_test
% NOTE: In case of a draw, classify depending on the average of the metrics values
% NOTE 2: Tune params to enhance feature matching

indexPairsK = matchFeatures(feat_kermit_train,feat_kermit_test,'MatchThreshold',5,'Metric','SSD');  
indexPairsM = matchFeatures(feat_multipla_train,feat_kermit_test,'MatchThreshold',5,'Metric','SSD');

numMatchesK = size(indexPairsK,1);
numMatchesM = size(indexPairsM,1);

if numMatchesK > numMatchesM
    pred_kermit_test = 'kermit';
elseif numMatchesM > numMatchesK
    pred_kermit_test = 'multipla';
else
    metrics1 = mean(indexPairsK.Metric);
    metrics2 = mean(indexPairsM.Metric);
    if metrics1 > metrics2
        pred_kermit_test = 'kermit';
    else
        pred_kermit_test = 'multipla';
    end
end


fprintf('Resultat predicció Kermit: %s\n', pred_kermit_test);


%% TEST 6 (1.5 points)
% Visualize feature matching from the classified image (showMatchedFeatures.m)

matchedTrainK = valid_pointsTrainK(indexPairsK(:, 1));
matchedTestK = valid_pointsTestK(indexPairsK(:, 2));
figure;
showMatchedFeatures(kermit_train, kermit_test, matchedTrainK, matchedTestK,"montage");title('Match Kermit-Kermit');

matchedTrainM = valid_pointsTrainM(indexPairsM(:, 1));
matchedTestM = valid_pointsTestM(indexPairsM(:, 2));
figure;
showMatchedFeatures(multipla_train, kermit_test, matchedTrainM, matchedTestM,"montage");title('Match Multipla-Kermit');

%% TEST 7 (3 points)
% Repeat Tests 6 & 7 for the classification of multipla_test
% Store the label in a variable called pred_multipla_test
% Visualize feature matching too


indexPairsK = matchFeatures(feat_kermit_train,feat_multipla_test,'MatchThreshold',5,'Metric','SSD');  
indexPairsM = matchFeatures(feat_multipla_train,feat_multipla_test,'MatchThreshold',5,'Metric','SSD');

numMatchesK = size(indexPairsK,1);
numMatchesM = size(indexPairsM,1);

if numMatchesK > numMatchesM
    pred_multipla_test = 'kermit';
elseif numMatchesM > numMatchesK
    pred_multipla_test = 'multipla';
else
    metrics1 = mean(indexPairsK.Metric);
    metrics2 = mean(indexPairsM.Metric);
    if metrics1 > metrics2
        pred_multipla_test = 'kermit';
    else
        pred_multipla_test = 'multipla';
    end
end

fprintf('Resultat predicció Multipla: %s\n', pred_multipla_test);

matchedTrainK = valid_pointsTrainK(indexPairsK(:, 1));
matchedTestK = valid_pointsTestK(indexPairsK(:, 2));
figure;
showMatchedFeatures(kermit_train, multipla_test, matchedTrainK, matchedTestK,"montage");title('Match Kermit-Multipla');

matchedTrainM = valid_pointsTrainM(indexPairsM(:, 1));
matchedTestM = valid_pointsTestM(indexPairsM(:, 2));
figure;
showMatchedFeatures(multipla_train, multipla_test, matchedTrainM, matchedTestM,"montage");title('Match Multipla-Multipla');









