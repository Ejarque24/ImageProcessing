%% PRACTICAL ASSIGNMENT #1. TRACTAMENT DIGITAL DE LA IMATGE 2022-2023
%% MODULE B

%% Group number (PDI1, PDI2, etc.): PDI6

function [iris_brown, mask_iris_brown] = moduleB()

    close all;
    
    % Read the brown eye image
    img_brown_eye = imread('BrownEye.jpg');

    % Initialize the variable that will contain the segmented iris of the eye
    iris_brown = []; 
    % Initialize the variable that will contain the binary mask of the
    % segmented iris of the eye
    mask_iris_brown = [];

    %% Write your code here

    %Mostrem la imatge en pantalla completa (fer facilitar el drawFreeHand)
    f1 = figure();
    imshow(img_brown_eye);
    f1.WindowState = 'maximized';

    %DrawFreeHand de l'exterior de l'iris
    h = drawfreehand;
    BW = createMask(h);    
    iris_brown_aux = img_brown_eye;

    % Apliquem la mascara del createMask a la imatge original
    iris_brown_aux(:,:,:) = uint8( BW .* double(img_brown_eye(:,:,:)) );

    %Mostrem la imatge en pantalla completa (fer facilitar el drawFreeHand)
    imshow(iris_brown_aux);
    f1.WindowState = 'maximized';

    %DrawFreeHand de l'interior de l'iris per a eliminar la pupila
    h2 = drawfreehand;
    BW2 = createMask(h2);   
    iris_brown = iris_brown_aux;

    % Apliquem la mascara del createMask a la imatge original
    iris_brown(:,:,:) = uint8( ~BW2 .* double(iris_brown_aux(:,:,:)) );

    close(f1);
    figure;
    imshow(iris_brown);
    
    %Restem  les dues mascares per restar-hi la pupila
    mask_iris_brown = BW-BW2;
    figure;
    imshow(mask_iris_brown);

    %Obtenim els valors R,G i B de l'imatge
    R=imhist(iris_brown(:,:,1));
    G=imhist(iris_brown(:,:,2));
    B=imhist(iris_brown(:,:,3));

    % Com que no volem tenir en compte els negres de la imatge, posem a 0 els seus valors al histograma, ja que hi ha un nombre molt elevat de píxels negres
    R(1) = 0;
    G(1) = 0;
    B(1) = 0;

    %Els mostrem en un plot limitat en x[0,300] i y[0,250]
    figure;
    plot(R,'r');
    xlim([0 300]);
    ylim([0 250]);
    hold on
    plot(G,'g');
    xlim([0 300]);
    ylim([0 250]);
    hold on
    plot(B,'b');
    xlim([0 300]);
    ylim([0 250]);

    legend('Red channel','Green channel','Blue channel');
    hold off;

    % Save the segmented iris as an image file called 'iris_brown.png'
    imwrite(iris_brown, 'iris_brown.png'); 

    % Save the binary mask of the segmented iris as an image file called 'mask_iris_brown.png'
    imwrite(mask_iris_brown, 'mask_iris_brown.png');

end




