A=[string('Closed'),string('Partially Closed'),string('Open')];

for j=1:3

    F = char(strcat('Faces/',A(j),'/*.jpg'));
    imagefiles = dir(F); 
    totalFiles = length(imagefiles);    

    for i=1:totalFiles
       i
       currentfilename = imagefiles(i).name;
       I = imread(char(strcat('Faces/',A(j),'/',currentfilename)));
       EyeDetect = vision.CascadeObjectDetector('EyePairBig');
       BB=step(EyeDetect,I);
       subImage = imcrop(I, BB);

       imwrite(subImage,char(strcat('Eyes/',A(j),'/',int2str(i),'.jpg')));

       %imshow(subImage)


    end

end




% v = VideoReader('CV_Videos/file.mp4');
% video = read(v,[1 Inf]);
% [x,y,p,f]=size(video);
% for i=1:1:f
% 
% imwrite(video(:,:,:,i),strcat('CV_Images/',int2str(i+800),'.jpg'))
% end
% 
% 
% imshow(images{i})