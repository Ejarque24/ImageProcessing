%% PRACTICAL ASSIGNMENT #1. TRACTAMENT DIGITAL DE LA IMATGE 2022-2023
%% MODULE C

%% Group number (PDI1, PDI2, etc.): PDI6


function moduleC()
    
    close all
    % Read the blue eye image
    img_blue_eye = imread('BlueEye.jpg');

    %Read the BrownEye1.jpg image
    img_brown_eye = imread('BrownEye.jpg');
    
    % Read the brown iris image
    iris_brown = imread('iris_brown.png');

    % Read the binary mask of the brown iris
    mask_iris_brown = imread('mask_iris_brown.png');
    
    %% Write your code here

    % Fem una máscara dels colors blancs per fer una primera neteja al ull. Ho hem fet perque quan estavem aïllant el iris hi havia blanc residual al seu voltant
    img_gray = rgb2gray(img_blue_eye);
    white_mask = img_gray > 170;
    
    % Netegem la mascara binaritzada per poder multiplicarla per la imatge i eliminar els blancs
    mask = ~imbinarize(double(white_mask));
    img_blue_eye = img_blue_eye .* uint8(cat(3, mask, mask, mask));
    
    %Obtenim el hue de la tonalitat blava i fem threshold 
    img_blue_eye_hsv = rgb2hsv(img_blue_eye);
    blue_hue = img_blue_eye_hsv(:,:,1);

    % Aquest threshold surt de fer prova i error, per acotar els blaus que representen el iris.
    blue_iris_mask = blue_hue > 0.3 & blue_hue < 0.8;

    %Per a acabar de pulir el retall apliquem tecniques de morfologia matematica
    se = strel('disk', 5);
    ste = strel('disk', 2);
    blue_iris_mask = imopen(blue_iris_mask, se);
    blue_iris_mask = imclose(blue_iris_mask, se);
    blue_iris_mask = imerode(blue_iris_mask, ste);

    % Apliquem la mascara final al ull blau per obtenir-ne el iris
    blue_iris = img_blue_eye .* uint8(cat(3, blue_iris_mask, blue_iris_mask, blue_iris_mask));

    % Fem el mateix amb l'ull marró però amb la mascara que estava al fitxer
    mask_iris_brown = imbinarize(mask_iris_brown);    
    iris_brown = iris_brown .* uint8(cat(3, mask_iris_brown, mask_iris_brown, mask_iris_brown));
    
    % Fem matching de histogramas per passar els colors blaus als marrons.
    B = imhistmatch(iris_brown,blue_iris);
    
    % Apliquem la mascara del ull marró al resultat del histograma
    iris_brown_new = B .* uint8(mask_iris_brown);

    % Apliquem la del ull marró negada al ull marró original per fer desaparéixer el iris original, i poder posar el nou iris que hem "recalculat" amb el imhistmatch
    img_brown_eye = img_brown_eye .* uint8(~mask_iris_brown);

    % Com que la img_brown_eye té un espai negre on hauría de estar el blanc, i el iris_brown_new es tot negre excepte al iris, sumem les imatges per "posar" el iris nou a la imatge original
    img_brown_final = img_brown_eye + iris_brown_new;

    %Mostrem les dues imatges originals i el resultat final
    figure;
    subplot(1,3,1);
    imshow(imread('BrownEye.jpg'));
    subplot(1,3,2);
    imshow(imread('BlueEye.jpg'));
    subplot(1,3,3);
    imshow(img_brown_final);


    
end



