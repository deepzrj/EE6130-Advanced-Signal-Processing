%==========================================================================
%                        EXTRACT MATCHED FEATURES
%
%   This script is responsible for extracting matching points between images. 
% Receives a pair of stereo images as a parameter, and returns the matching
% points between them.
%==========================================================================

function [lPoints, rPoints] = extractMatchedFeatures(lImage, rImage)

%   Detects the corners of each image using the corner detection algorithm.
% The Min8Val algorithm had the best results in a previous analysis.
surfL = detectMinEigenFeatures(lImage);
surfR = detectMinEigenFeatures(rImage);

%   Calculates the matches between the obtained corners of each image, using
% the Sum of Squared Differences (SSD).
[ftrsL, vldPtsL] = extractFeatures(lImage, surfL);
[ftrsR, vldPtsR] = extractFeatures(rImage, surfR);

index = matchFeatures(ftrsL, ftrsR, 'Unique', true);

lPoints = vldPtsL(index(:,1),:);
rPoints = vldPtsR(index(:,2),:);

%   Ends the script.
end