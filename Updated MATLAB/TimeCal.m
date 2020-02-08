% created by Md Yousuf Harun (mdyousuf@hawaii.edu)
function tB1 = TimeCal(filename)
currentfolder = pwd;
subfolder = erase(filename,".avi");
p = strcat(currentfolder,'\', subfolder, '\*.png');
S = dir(p);
%S = dir('D:\Yousuf_Net\Other Patients\10DWYER\DWYERwells_1.4_video10618\*.png');
N = {S.name};
C = cell(size(N));
roi = [450 478 39 10]; % figure; imshow(I); roi = round(getPosition(imrect))
T = [];
M = [];
A = '0123456789';
newfolder = strcat(currentfolder, '\', subfolder);

cd(newfolder); % Change directory to access files

 for k = 1:numel(N)
     I = imread(N{k});
     I1 = imcrop(I,roi);
     I2 = imsharpen(I1);
     I3 = rgb2gray(I2);
     I4 = imbinarize(I3);
     I5 = imresize(I4,1.4);
     I6 = regionprops(I5,'BoundingBox','Area', 'Image');
     I7 = I6.Image;
     results = ocr(I7,'CharacterSet', '.0123456789h', 'TextLayout','Block');
     m = results.Text;
     for r = 1:length(m)
         if ismember(m(1,r),A)
            M = [M m(1,r)];
         end
     end
     M1 = str2double(M);
     M2 = M1/10;
     T(k,1) = M2;
     M = [];
 end
 
 time(1,1) = 0;
 for j = 2:length(T)
     diff = T(j,1)-T(j-1,1);
     time(j,1) = diff + time(j-1,1);
 end 
 
 cd(currentfolder); % change directory and return to previous folder
 
 destination = strcat(currentfolder, '\', subfolder);
 name1 = strcat(subfolder,'_tB_hr','.csv');
 name2 = strcat(subfolder,'_duration_hr','.csv');
 fname1 = strcat(destination,'\', name1);
 fname2 = strcat(destination,'\', name2);
 writematrix(T,fname1);
 writematrix(time,fname2);
 %save T;
 %save time;
 tB1 = T(1); % initial time of blastocyst formation
 end