%Modify lines 2-7 as desired
isImage = 0;
isGray = 1;
startFrameNumber = 726; %how many frames before the frame you start renaming
degrees = 270; %degrees
widthlength = 256; %size of the resized image
mirror = 0; %mirror over y axis = 1; mirror over x axis = 2; no mirror = 0
originalpath = '/Users/wilzh/Desktop/Fall 2019/Videos/296x296/Labels/';
newpath = '/Users/wilzh/Desktop/';

type = 'Labels';
if(isImage == 1)
    type = 'Images';
end
files = dir(strcat(originalpath,'/*.png'));
if(degrees == 0 && mirror == 0)
    N = strcat(newpath, type, ', ', num2str(widthlength), 'x', num2str(widthlength));
elseif(mirror ~= 0)
    if(mirror == 1)
        N = strcat(newpath, type, ', ', num2str(widthlength), 'x', num2str(widthlength), ', Rotated_', num2str(degrees), ', MirrorX');
    else
        N = strcat(newpath, type, ', ', num2str(widthlength), 'x', num2str(widthlength), ', Rotated_', num2str(degrees), ', MirrorY');
    end
else
    N = strcat(newpath, type, ', ', num2str(widthlength), 'x', num2str(widthlength), ', Rotated_', num2str(degrees));
end
mkdir(N);
for k = 1:length(files)
    lengthFile = length(files);
    Image = imread(strcat(originalpath, files(k).name));
    if(isImage == 1 && isGray == 0)
       Image = rgb2gray(Image); 
    end
    if(degrees ~= 0)
        Image = imrotate(Image, degrees);
        Image = label2rgb(Image);
        [r, c, ~] = size(Image);
        val1 = Image(1,1,1);
        val2 = Image(1,1,2);
        val3 = Image(1,1,3);
        for p = 1:r
            for l = 1:c
                if(Image(p,l,1) == val1 && Image(p,l,2) == val2 && Image(p,l,3) == val3)
                    Image(p,l,1) = 0;
                    Image(p,l,2) = 0;
                    Image(p,l,3) = 255;
                end
            end
        end
        [Image, map] = rgb2ind(Image, 2);
    end
    if(mirror ~= 0)
        if(mirror == 1)
            Image = flipud(Image);
        else
            Image = flip(Image,2);
        end
    end
    Image = imresize(Image, [widthlength widthlength]); %change size of image (x,y)
    if(combine == 1)
        nextImage = imread(strcat(originalpath, files(lengthFile).name));
        sizeImage = size(Image);
        totalpixels_x = sizeImage(2);
        segment_x = totalpixels_x/2;
        if(lengthFile ~= k)
            I1(1:totalpixels_y,1:segment_x) = Image(1:totalpixels_y,1:segment_x);
            I1(1:totalpixels_y,segment_x+1:2*segment_x) = nextImage(1:totalpixels_y,segment_x+1:2*segment_x);
            I2(1:totalpixels_y,1:segment_x) = nextImage(1:totalpixels_y,1:segment_x);
            I2(1:totalpixels_y,segment_x+1:2*segment_x) = Image(1:totalpixels_y,segment_x+1:2*segment_x);
        end
        lengthFile = lengthFile - 1;
        filename=strcat(N, '/', num2str(k + startFrameNumber + w),'.png');
        imwrite(I1, filename);
        w = w + 1;
        filename=strcat(N, '/', num2str(k + startFrameNumber + w),'.png');
        imwrite(I2, filename);
    end
    if(combine == 0)
        filename=strcat(N, '/', num2str(k + startFrameNumber),'.png');
        imwrite(Image, filename);
    end
end