%Read image that needs to be mirrored
imageData = imread('C:\Users\chris\Documents\MATLAB\Labeled\mouse5201-exfr-COPY\PixelLabelData\Label_1.png');

%Mirror image over y-axis (mirror side-by-side)
mirrory = flip(imageData,1);
mirrory = flip(imageData,2);

%Display mirrory image
imshow(mirrory);

%Save output figure to .png in MATLAB folder
saveas(gcf,'Label_1-flipy.png');

