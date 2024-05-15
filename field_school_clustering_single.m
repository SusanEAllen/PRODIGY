%% Script for clustering SalishSeaCast data (single variable)

clearvars

% The location of the file - change it to the directory you extracted it
% Printing the features of the dataset
ncdisp('field_school.nc')

% Keeping the quantities of interest in separate variables
temperature = ncread('C:\Users\ilias\Desktop\field_school.nc', 'Temperature');
salinity = ncread('C:\Users\ilias\Desktop\field_school.nc', 'Salinity');
diatoms = ncread('C:\Users\ilias\Desktop\field_school.nc', 'Diatoms');
x = ncread('C:\Users\ilias\Desktop\field_school.nc', 'x');
y = ncread('C:\Users\ilias\Desktop\field_school.nc', 'y');

% Defining y and x regions
x_min = min(x)+1; % We start from 1
x_max = max(x)+1;
y_min = min(y)+1;
y_max = max(y)+1;

% Plotting diatoms for the first depth and for the whole region
figure
pcolor(x,y,(diatoms(:,:,1)'));
shading interp;
title('Diatom Concentration [mmol m-3]')
colorbar

% Clustering

    % Clustering at the 0th depth
inputs = diatoms(x_min:x_max,y_min:y_max,1);
n_clusters = 5;

    % Pre-processing

        % Making the variable flat
inputs2 = reshape(inputs,1,[]);

        % Finding Nans
indx = (~isnan(inputs2));
inputs2 = inputs2(indx);

        % Transposing the input variable
inputs2 = inputs2';

        % Normalization of the values
inputs2 = (inputs2 - min(inputs2)) / (max(inputs2) - min(inputs2));

    % Clustering - different algorithm from the Python script
predictions = kmeans(inputs2,n_clusters);

    % Post processing
clusters = NaN(length(x),length(y));
clusters(indx) = predictions;

% Printing
for i = 1:5
    
    X = ['The amount of grid boxes for cluster ', num2str(i), ' is: ', num2str(length(predictions(predictions==i)))];
    disp(X)
    
end

% Plotting 

figure
subplot(1,2,1);
pcolor(x,y,clusters')
shading interp
title('Clusters [count]')
colorbar

subplot(1,2,2);
pcolor(x,y,inputs')
shading interp
title('Diatom Concentration [mmol m-3]')
colorbar
