netLabelPath = 'C:\Users\Joel\Desktop\SPRING 2020\EE 496\MATLAB\D2019.07.10_S00701_I0746_D_wells_AA2(4981)_video_new\'; %path to network labeled images after Output script
files = dir(strcat(netLabelPath,'*.png'));

pixelToMicron = 0.3364;     %1x1 pixel = 0.3364 microns squared

embryoSizePx = zeros(1,length(files));
for i=1:length(files)
    Image = imread(files(i).name);
    Image = rgb2gray(Image);            %rgb to gray to binarize conversions produced inaccuracy of # of pixel labels
    Image = imbinarize(Image,'adaptive','ForegroundPolarity','bright','Sensitivity',0.5);
    embryoSizePx(i) = sum(sum(Image));
end

embryoSizePx = embryoSizePx*pixelToMicron;
frameNum = 1:length(files);
plot(frameNum,embryoSizePx); xlabel('Frame Number'); ylabel('Micrometers^2');
title('Embryo Growth Rate');