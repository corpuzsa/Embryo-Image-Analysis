files = dir('*.png'); % make sure to place the program in the folder with images you want to crop

w = 0; %how many frames BEFORE the frame you start cropping into 4
for k = 1:length(files)
        I = imread(files(k).name);
        sizeI = size(I);
        totalpixels_y = sizeI(1); % gets # of pixels of one image axis
        totalpixels_x = sizeI(2);
        segment_y = totalpixels_y/2; % takes total pixels in one axis and divides by 4
        segment_x = totalpixels_x/2;
        I1 = I(1:segment_y, 1:segment_x);
        I2 = I(1:segment_y, segment_x+1:2*segment_x);
        I3 = I(segment_y+1:2*segment_y, 1:segment_x);
        I4 = I(segment_y+1:2*segment_y, segment_x+1:2*segment_x);
        imwrite(I1, strcat('Cropped_Label_', num2str(k + w), '_Quarter1', '.png')); %change name respective to crop either extracted frames or labeled frames
        imwrite(I2, strcat('Cropped_Label_', num2str(k + w), '_Quarter2', '.png'));
        imwrite(I3, strcat('Cropped_Label_', num2str(k + w), '_Quarter3', '.png'));
        imwrite(I4, strcat('Cropped_Label_', num2str(k + w), '_Quarter4', '.png'));
end