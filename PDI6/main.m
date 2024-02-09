%% PRACTICAL ASSIGNMENT #1. TRACTAMENT DIGITAL DE LA IMATGE 2022-2023
%% MAIN

%% Group number (PDI1, PDI2, etc.): PDI6

% Choose the module that must be executed
list = {'Module A', 'Module B', 'Module C'};
[idx, tf] = listdlg('ListString', list, 'SelectionMode', 'single');

% Check valid option
if isempty(idx)
    disp('No option was chosen');
    return
end

% Depending on the chosen module, run it
switch list{idx}
    case 'Module A'
        reflections_percentage = moduleA();
    case 'Module B'
        [iris_brown, mask_iris_brown] = moduleB();
    case 'Module C'
        moduleC();
end
