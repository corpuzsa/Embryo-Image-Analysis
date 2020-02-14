function tB1 = timeCalc(imagename)
roi = [452 472 35 15]; 
A = '0123456789';
M = [];

I = imcrop(imagename,roi);
I = imsharpen(I);
I = imbinarize(I);
I = bwmorph(I, 'thicken', 1);
I = imresize(I,1.5);
results = ocr(I,'CharacterSet', '.0123456789h', 'TextLayout','Line');
m = results.Text;
for r = 1:length(m)
    if ismember(m(1,r),A)
        M = [M m(1,r)];
    end
end
M1 = str2double(M);
tB1 = M1/10;
 end