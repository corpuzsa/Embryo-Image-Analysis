% Time recognition function that reads and records
% time within the ROI (Region of Intrest) and places
% time into an array

function [time,T] = timerec(name)

% Initialize the diff time to be zero
time(1,1) = 0;

% Initialize matrices and important characters for recognition
T = [];
M = [];
A = '0123456789';
 
% Save the path of folder containing time lapse pics (Grayscale)
% '/*.png' depends on the path your computer generates
% '/*.png' for mac OS
% '\*.png' for Windows/Linux
p = strcat(name, '/*.png');

% Access all files within the folder
S = dir(p);

% Store names of photos within a cell
N = {S.name};

% Region of Interest
% Derived from: figure; imshow(I); roi = round(getPosition(imrect))
roi = [453 473 33 15];

% For every picture in the folder
for k = 1:numel(N)
    
     % Use OCR to save time
     % If using photos not already in grayscale,
     % I3 = rgb2gray(I2);
     I = imread(N{k});
     I1 = imcrop(I,roi);
     I2 = imsharpen(I1);
     I3 = imbinarize(I2);
     I4 = imresize(I3,1.4);
     I5 = regionprops(I4,'BoundingBox','Area', 'Image');
     I6 = I5.Image;
     
     results = ocr(I6,'CharacterSet', '.0123456789h', 'TextLayout','Block');
     
     m = results.Text;
     
     % Numerical Filter, catches Characters specified in A
     for r = 1:length(m)
         if ismember(m(1,r),A)
            M = [M m(1,r)];
         end
     end
     
     M1 = str2double(M);
     
     % Conversion to correct time (with decimal)
     M2 = M1/10;
     
     % Save time T
     T(k,1) = M2;
     
     % Empty M matrix
     M = [];
end

 % Calculate the difference in time (Intervals)
 for j = 2:length(T)
     diff = T(j,1)-T(j-1,1);
     time(j,1) = diff + time(j-1,1);
 end 

