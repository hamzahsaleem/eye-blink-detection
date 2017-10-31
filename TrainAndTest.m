A=[string('Closed'),string('Partially Closed'),string('Open')];
HogFeatures=zeros(300,8568);
k=1;

for j=1:3

    F = char(strcat('Eyes/',A(j),'/*.jpg'));
    imagefiles = dir(F); 
    totalFiles = length(imagefiles);    
    
    
    for i=1:totalFiles
       
       currentfilename = imagefiles(i).name;
       I = imread(char(strcat('Eyes/',A(j),'/',currentfilename)));
       reshapedImg = rgb2gray(imresize(I, [70, 280]));
       [featureVector,hogVisualization] = extractHOGFeatures(reshapedImg);
       HogFeatures(k,:) = featureVector;
       k=k+1;
       
    end

end


train_labels = zeros(300,1);
train_labels(1:100,1) = 1;
train_labels(101:200,1) = 2;
train_labels(201:300,1) = 3;


SVM_Model = fitcecoc(HogFeatures,train_labels);



v = VideoReader('vid2.mp4');
video = read(v,[1 Inf]);
[x,y,p,f]=size(video);

HogFeatures=zeros(int32(f),8568);
k=1;

for i=1:1:f
    
    I = video(:,:,:,i);
    %imshow(I)
    EyeDetect = vision.CascadeObjectDetector('EyePairBig');
    BB=step(EyeDetect,I);
    try
        subImage = imcrop(I, BB);
        reshapedImg = rgb2gray(imresize(subImage, [70, 280]));
        
        [featureVector,hogVisualization] = extractHOGFeatures(reshapedImg);
        HogFeatures(k,:) = featureVector;
        k=k+1;
       
    catch
        continue;
    end   
    
end

predictions = predict(SVM_Model,HogFeatures(1:k-1,:));

i=1;
m=1;

pred_modified = zeros(1,int32(k/2));

while i<k-2
    curr_predict = predictions(i,1);
    pred_modified(1,m) = curr_predict;
    m= m+1;
    i=i+1;
    next_predict = predictions(i,1);
   
    
    
    while curr_predict == next_predict && i<k-1 
        i=i+1;
        next_predict = predictions(i,1);
        
    end
    
    
end    


if predictions(k-1,1)~= pred_modified(1,m-1)
    pred_modified(1,m) = predictions(k-1,1);
end    
    
no_of_blinks = 0;
i=1;






while i < m

    if( (i+4 < m) && pred_modified(1,i) == 3 && pred_modified(1,i+1) == 2 && pred_modified(1,i+2) == 1 && pred_modified(1,i+3) == 2 && pred_modified(1,i+4) == 3)
        no_of_blinks = no_of_blinks + 1;
        i = i+4;
    
    elseif((i+3 < m) && pred_modified(1,i) == 3 && pred_modified(1,i+1) == 2 && pred_modified(1,i+2) == 1 && pred_modified(1,i+3) == 2)    
        no_of_blinks = no_of_blinks + 1;
        i = i+3;
    
    elseif((i+3 < m) && pred_modified(1,i) == 3 && pred_modified(1,i+1) == 2 && pred_modified(1,i+2) == 1 && pred_modified(1,i+3) == 3)    
        no_of_blinks = no_of_blinks + 1;
        i = i+3;
    
    elseif((i+3 < m) && pred_modified(1,i) == 3 && pred_modified(1,i+1) == 1 && pred_modified(1,i+2) == 2 && pred_modified(1,i+3) == 3)    
        no_of_blinks = no_of_blinks + 1;
        i = i+3;
    
    elseif((i+2 < m) && pred_modified(1,i) == 3 && pred_modified(1,i+1) == 1 && pred_modified(1,i+2) == 2)    
        no_of_blinks = no_of_blinks + 1;
        i = i+2;
    
    elseif((i+2 < m) && pred_modified(1,i) == 3 && pred_modified(1,i+1) == 1 && pred_modified(1,i+2) == 3)    
        no_of_blinks = no_of_blinks + 1;
        i = i+2;
    
    elseif((i+3 < m) && pred_modified(1,i) == 2 && pred_modified(1,i+1) == 1 && pred_modified(1,i+2) == 2 && pred_modified(1,i+3) == 3)    
        no_of_blinks = no_of_blinks + 1;
        i = i+3;
    
    elseif((i+2 < m) && pred_modified(1,i) == 2 && pred_modified(1,i+1) == 1 && pred_modified(1,i+2) == 2)    
        no_of_blinks = no_of_blinks + 1;
        i = i+2;    
    
    elseif((i+2 < m) && pred_modified(1,i) == 2 && pred_modified(1,i+1) == 1 && pred_modified(1,i+2) == 3)    
        no_of_blinks = no_of_blinks + 1;
        i = i+2; 
    else    
        i=i+1;
        
    end
    
end

disp('No of blinks are: ')
disp(no_of_blinks)

