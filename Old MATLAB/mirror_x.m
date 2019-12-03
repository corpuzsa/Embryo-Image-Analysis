%Read image that needs to be mirrored
imageData = imread('C:\Users\chris\Documents\MATLAB\mouse5201-exfr-COPY\0121_mouse5201.png');

%Mirror image over x-axis (mirror upside-down)
mirrorx = flipud(imageData);

%Display mirrorx image
imshow(mirrorx);

%Save output figure to .png in MATLAB folder
saveas(gcf,'0121mouse5201-flipx.png');