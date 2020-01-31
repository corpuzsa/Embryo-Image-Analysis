output = ["Videos","Time (h)","Initial Size (um^2)","Final Size (um^2)","Final Size Rank","Average Growth Rate","Avg Growth Rate Rank"];
realTime = 4;
imageSize = 256;
pixel2real = 0.6203;

load('full_network1.mat', 'net');
count = 0;

file = '/Users/wchang/Desktop/VIP/Video/4981.avi';
[filepath,name,ext] = fileparts(file);
mkdir(name);
mkdir(strcat(name, '_new'));
vidObj = VideoReader(file);
time_to_remember = vidObj.CurrentTime;
numFrames = 0;
path = strcat(filepath,'/',name);
totalTime;

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
    Image = imresize(Image, [256 256]);
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

name = convertCharsToStrings(name);
array = [name realTime pixelArray(1) (pixelArray(numFrames)*pixel2real) name name name];
output = [output; array];

writematrix(output, 'embryo_results.csv');
