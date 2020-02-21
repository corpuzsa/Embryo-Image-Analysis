clear; clc; 
%% Create table headers
output = ["Videos","Time (h)","Initial Size (um^2)","Final Size (um^2)","Final Size Rank","Average Growth Rate","Avg Growth Rate Rank"];
%% Define set variables
realTime = 4;
imageSize = 496;
pixel2real = 0.58*0.58;
%% Load neural network (in same directory)
load('net_all_combined_all.mat', 'net');
%% Create empty variables
%count = 0;
files = [];
%% Receive input on how many videos being processed and initialize
numVideos = input("How many videos are you processing? ");
rankGrowth = zeros(numVideos, 2);
rankSize = zeros(numVideos, 2);
%% Ask for filepath
    % EX: /Users/wchang/Desktop/VIP/Video/4981.avi
for i=1:numVideos
    fprintf("Video %.0f\n", i);
    in = input("What is the filepath? ", 's'); 
    files = [files; string(in)];
    rankGrowth(i) = i;
    rankSize(i) = i;
end
tic
%% For each video...
for i=1:numVideos
    file = files(i);
    [filepath,name,ext] = fileparts(file);
    % Make a directory for original images
    mkdir(name);
    % Make a directory for predicted images
    mkdir(strcat(name, '_new'));
    vidObj = VideoReader(file);
    time_to_remember = vidObj.CurrentTime;
    numFrames = 0;
    path = strcat(filepath,'/',name);
    % Get count of total number of images
    while hasFrame(vidObj)
        readFrame(vidObj);
        numFrames = numFrames + 1;
    end
    totalTime = vidObj.CurrentTime;
    pixelArray = zeros(1,numFrames);
    timeArray = zeros(1,numFrames);
    vidObj.CurrentTime = time_to_remember;
    %% For each image...
    for k=1:numFrames
        %count = 0;
        % Convert image to correct size and type for CNN
        Image = readFrame(vidObj);
        Image = rgb2gray(Image);
        Image = imresize(Image, [imageSize imageSize]);
        timeArray(k) = timeCalc(Image);
        if(k<10)
            filename=strcat(name,'/','00',num2str(k),'_',name,'.png');
        elseif(k>=10 && k<=99)
            filename=strcat(name,'/','0',num2str(k),'_',name,'.png');    
        else
            filename=strcat(name,'/',num2str(k),'_',name,'.png');
        end
        strcat(filepath,'/',name,'/',filename);

        imwrite(Image,filename,'png');
    
        [C,scores] = semanticseg(Image, net);
        pixelArray(k) = sum(C(:) == "Embryo")*pixel2real;
        Image = labeloverlay(Image, C);
        if(k<10)
            filename=strcat(name,'_new','/','00',num2str(k),'_',name,'.png');
        elseif(k>=10 && k<=99)
            filename=strcat(name,'_new','/','0',num2str(k),'_',name,'.png');    
        else
            filename=strcat(name,'_new','/',num2str(k),'_',name,'.png');
        end
        strcat(filepath,'_new','/',name,'/',filename);

        imwrite(Image,filename,'png');
    end

    disp(timeArray);
    baseTime = timeArray(1);
    for k=1:numFrames
       timeArray(k) = timeArray(k) - baseTime; 
    end
    
    rankSize(i,2) = pixelArray(numFrames);
    P = linearRegression(pixelArray, timeArray);
    rankGrowth(i,2) = P(1);
    name = convertCharsToStrings(name);
    array = [name timeArray(numFrames) pixelArray(1) pixelArray(numFrames) 1 rankGrowth(i,2) 1];
    output = [output; array];
end

%% If there are more than 1 videos...
if(numVideos ~= 1)
    %% Insertion sort for the final size
    for i=2:numVideos
        key = rankSize(i, 2);
        m = i - 1;
    
        while(m >= 1 && rankSize(m, 2) > key)
            rankSize(m+1, 2) = rankSize(m, 2);
            rankSize(m+1, 1) = rankSize(m, 1);
            m = m - 1;
        end
        rankSize(m+1, 2) = key;
        rankSize(m+1, 1) = i;
    end
    %% Insertion sort for the growth rate
    for i=2:numVideos
        key = rankGrowth(i, 2);
        m = i - 1;
    
        while(m >= 1 && rankGrowth(m, 2) > key)
            rankGrowth(m+1, 2) = rankGrowth(m, 2);
            rankGrowth(m+1, 1) = rankGrowth(m, 1);
            m = m - 1;
        end
        rankGrowth(m+1, 2) = key;
        rankGrowth(m+1, 1) = i;
    end
    %% Insert rankings into the matrix
    for i=1:numVideos
        output(1+rankSize(i), 5) = numVideos + 1 - i;
        output(1+rankGrowth(i), 7) = numVideos + 1 - i;
    end
end
toc
%% Print results in csv file
writematrix(output, 'embryo_results.csv');