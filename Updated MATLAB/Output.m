% Initialize necessary variables
output = ["Videos","Time (h)","Initial Size (um^2)","Final Size (um^2)","Final Size Rank","Average Growth Rate","Avg Growth Rate Rank"];
realTime = 4;
imageSize = 496;
pixel2real = 0.58*0.58;
load('net_all_combined_all.mat', 'net');
count = 0;
files = [];
timePerFrame = realTime/121;

% Receive input on how many videos being processed and initialize
numVideos = input("How many videos are you processing? ");
rankGrowth = zeros(numVideos, 2);
rankSize = zeros(numVideos, 2);
timeArray = zeros([121 1]);

for l=1:121
    timeArray(l) = l*timePerFrame;
end
for p=1:numVideos
    fprintf("Video %.0f\n", p);
    in = input("What is the filepath? ", 's'); 
    files = [files; string(in)];
    rankGrowth(p) = p;
    rankSize(p) = p;
end
%'/Users/wchang/Desktop/VIP/Video/4981.avi'
for o=1:numVideos
    file = files(o);
    [filepath,name,ext] = fileparts(file);
    mkdir(name);
    mkdir(strcat(name, '_new'));
    vidObj = VideoReader(file);
    time_to_remember = vidObj.CurrentTime;
    numFrames = 0;
    path = strcat(filepath,'/',name);

    while hasFrame(vidObj)
        readFrame(vidObj);
        numFrames = numFrames + 1;
    end
    totalTime = vidObj.CurrentTime;
    pixelArray = zeros(1,numFrames);

    vidObj.CurrentTime = time_to_remember;
    
    for k=1:numFrames
        count = 0;
        Image = readFrame(vidObj);
        Image = rgb2gray(Image);
        Image = imresize(Image, [imageSize imageSize]);
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
        for l=1:imageSize
            for i=1:imageSize
                if(C(l,i) == "Embryo")
                    count = count + 1;
                end
            end
        end
        pixelArray(k) = count;
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

    rankSize(o,2) = pixelArray(numFrames);
    rankGrowth(o,2) = linearRegression(pixelArray, timeArray);
    name = convertCharsToStrings(name);
    array = [name realTime (pixelArray(1)*pixel2real) (pixelArray(numFrames)*pixel2real) 0 rankGrowth(o,2) 0];
    output = [output; array];
end

for j=1:numVideos
    key = rankSize(j, 2);
    m = j - 1;
    
    while(m >= 0 && rankSize(m, 2) > key)
        rankSize(m+1, 2) = rankSize(m);
        m = m - 1;
    end
    rankSize(m+1, 2) = key;
end
writematrix(output, 'embryo_results.csv');