clear all 
file = '/Users/josh/Documents/school/x96/droplet/droplettest2_0001.avi'; %%%change this to your directory 
 [filepath,name,ext] = fileparts(file); %%% break the path into pieces for later use
% mkdir(name); %%% make the folder
 vidObj = VideoReader(file); %%%store the video as a variable
 time_to_remember = vidObj.CurrentTime; %% remember the beginning of the video
 numFrames = 0; %% declare numFrames variable
 path = strcat(filepath,'/',name); %%%path string
 
    
    while hasFrame(vidObj) %%% frame counting loop
        readFrame(vidObj);
        numFrames = numFrames + 1;
    end
    
    vidObj.CurrentTime = time_to_remember;  %%% reset video to beginning
    Image = {1:numFrames};
    dropletCount = 0;
    flag = 0;
    for k=1:numFrames 
        Image{k} = readFrame(vidObj);  %%% read the frame
        meanValues = mean(Image{k});
        
        if k == 1
               [rows, columns, ~] = size(Image{k}); 
        end
        
        farCol(k) = meanValues(columns);
        
        if ((farCol(1) - farCol(k)) >= .7) && flag==0
            dropletCount = dropletCount + 1;
            flag = 1;
        end
        
        if ((farCol(1) - farCol(k)) < .2)
           flag = 0; 
        end
    end