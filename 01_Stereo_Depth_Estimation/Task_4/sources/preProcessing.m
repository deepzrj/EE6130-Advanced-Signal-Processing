%==========================================================================
%                              PRE-PROCESSING
%
%   This script is responsible for the pre-processing (for now, just an
% greyscale conversion and resizing) for each stereo image.
%
%   (Maybe I'll try new concepts in the future, so stay alert!)
%==========================================================================

function [lImage, rImage] = preProcessing(lImage, rImage, imgSize)

%	Greyscale conversion (if needed).
if size(lImage, 3) == 3
    lImage = rgb2gray(lImage);
    rImage = rgb2gray(rImage);
end

%   Increases the image intensity (contrast) of each images.
lImage = imadjust(lImage);
rImage = imadjust(rImage);

%   Increases the sharpness of each images.
lImage = imsharpen(lImage);
rImage = imsharpen(rImage);

%   Resizes the images.
lImage = imresize(lImage, imgSize);
rImage = imresize(rImage, imgSize);

%   Ends the script.
end