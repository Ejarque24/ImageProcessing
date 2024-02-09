%% 2223 - Exercise 1 - Color feature extraction and kNN image classification
% Name: Martí Ejarque Galindo

%% Summary: write the code in MATLAB to do the following:
% - Extract color features from 3 different Muppets images: the cookie monster, Elmo and Kermit.
% - Create a 3-NN classifier. It will use euclidean distance and use extracted color features.
% - Extract color features from a set of Muppets characters and classify them.

%% TEST 1 (1.25 points)
% Read over the cookie monster's images (Cookie_01.jpg, Cookie_02.jpg, ... , Cookie_10.jpg) and
% calculate the RGB percentage of every image
% Use 'cookie_rgb_percent' (10x3 matrix)
% NOTE: The operation consists on obtaining the percentage of pixels in the
% image whose R, G or B component is higher than the other ones
cookie_rgb_percent = zeros(10,3);
for i=1:10
    img=imread(sprintf('T4E1_Images/Cookie_%02d.jpg',i));
    size_img = size(img,1)*size(img,2);
    count = zeros(1,3);
    for j=1:size(img,1)
        for k=1:size(img,2)
            aux = img(j,k,:);
            [m,ind] = max(img(j,k,:));
            count(ind) = count(ind)+1;
        end
    end
    cookie_rgb_percent(i,:) = [(count(1)/size_img)*100,(count(2)/size_img)*100,(count(3)/size_img)*100];
end

%% TEST 2 (1.25 points)
% Repeat the process with Elmo's images (Elmo_01.jpg,
% Elmo_02.jpg, ... , Elmo_10.jpg)
% Use 'elmo_rgb_percent' (10x3 matrix)
elmo_rgb_percent = zeros(10,3);

for i=1:10
    img=imread(sprintf('T4E1_Images/Elmo_%02d.jpg',i));
    size_img = size(img,1)*size(img,2);
    count = zeros(1,3);
    for j=1:size(img,1)
        for k=1:size(img,2)
            aux = img(j,k,:);
            [m,ind] = max(img(j,k,:));
            count(ind) = count(ind)+1;
        end
    end
    elmo_rgb_percent(i,:) = [(count(1)/size_img)*100,(count(2)/size_img)*100,(count(3)/size_img)*100];
end

%% TEST 3 (1.25 points)
% Repeat the process with Kermit's images
% (Kermit_01.jpg, Kermit_02.jpg, ... , Kermit_10.jpg)
% Use 'kermit_rgb_percent' (10x3 matrix)
kermit_rgb_percent = zeros(10,3);

for i=1:10
    img=imread(sprintf('T4E1_Images/Kermit_%02d.jpg',i));
    size_img = size(img,1)*size(img,2);
    count = zeros(1,3);
    for j=1:size(img,1)
        for k=1:size(img,2)
            aux = img(j,k,:);
            [m,ind] = max(img(j,k,:));
            count(ind) = count(ind)+1;
        end
    end 
    kermit_rgb_percent(i,:) = [(count(1)/size_img)*100,(count(2)/size_img)*100,(count(3)/size_img)*100];
end

%% TEST 4 (1 point)
% Join the feature vectors (x_rgb_percentage) using the creation order in a
% single matrix
% Use 'X' (30x3 matrix)
X = zeros(30,3);
X = [cookie_rgb_percent; elmo_rgb_percent; kermit_rgb_percent];
%% TEST 5 (1 point)
% Create a 30x1 cell array that contains the corresponding Muppet label
% Use 'Y' (30x1 cell array)
% NOTE: Use 'cookie', 'elmo' and 'kermit' as labels
Y = cell(30,1); 
Y(1:10) = {'cookie'}; 
Y(11:20) = {'elmo'}; 
Y(21:30) = {'kermit'}; 

%% TEST 6 (1.5 points)
% Create a kNN classifier with 3 neighbors and an euclidean distance
% function (fitcknn.m)
% Use 'model'
model = fitcknn(X,Y,'NumNeighbors',3,'distance','euclidean');

%% TEST 7 (1.25 points)
% Repeat Test 1 process with the Muppet's images (Muppet_01.jpg, Muppet_02.jpg,
% ... , Muppet_10.jpg)
% Use 'muppet_rgb_percent'
muppet_rgb_percent = zeros(9,3);
muppets = {};
for i=2:10
    muppets{i-1}=imread(sprintf('T4E1_Images/Muppet_%02d.jpg',i));
    size_img = size(muppets{i-1},1)*size(muppets{i-1},2);
    count = zeros(1,3);
    for j=1:size(muppets{i-1},1)
        for k=1:size(muppets{i-1},2)
            aux = muppets{i-1}(j,k,:);
            [m,ind] = max(muppets{i-1}(j,k,:));
            count(ind) = count(ind)+1;
        end
    end 
    muppet_rgb_percent(i-1,:) = [(count(1)/size_img)*100,(count(2)/size_img)*100,(count(3)/size_img)*100];
end

%% TEST 8 (1.5 points)
% Classify the muppet images (predict.m) using 'muppet_rgb_percent' and display
% the results placing the name of each assigned label as the image title
% Use 'Y_pred'
Y_pred = predict(model,muppet_rgb_percent);
for i = 1:9
    subplot(3,3,i);
    imshow(muppets{i});
    title(Y_pred{i});
end