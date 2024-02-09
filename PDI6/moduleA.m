%% PRACTICAL ASSIGNMENT #1. TRACTAMENT DIGITAL DE LA IMATGE 2022-2023
%% MODULE A

%% Group number (PDI1, PDI2, etc.): PDI6


function reflections_percentage = moduleA()
    
    clear all;
    % Read the grayscale eye image
    img = imread('GrayscaleEye.png');

    
    %Initialize the variable that will contain the percentage of the image
    %corresponding to the reflections
    reflections_percentage = 0;
    
    %% Write your code here

    %Aïllem els valors blancs de la imatge i fem erode per a eliminar imperfeccions.
    img_white = im2double(img > 200);
    img_white_fill = imerode(img_white, strel('disk', 1));
    
    %Calculem el numero de pixels blancs de la imatge 
    num_zeros = sum(img_white_fill(:));

    %Calculem el numero total de pixels de la imatge 
    [height, width] = size(img);
    num_pixels = height*width;

    %Calculem el percentatge que ocuppen les reflxions i el mostrem per command window
    reflections_percentage = (num_zeros/num_pixels)*100;
    fprintf('The percentage of reflections is: %f%%\n', reflections_percentage);
    
end
