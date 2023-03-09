%==========================================================================
%                               LOAD IMAGES
%
%   This script is responsible for load an image pair from a given database.
%==========================================================================

function [lImage, rImage, error] = loadImages(scene, type)

%	Loads the files from a directory.
pathL = strcat('../dataset/stereorectification/', scene, '/im0.', type);
pathR = strcat('../dataset/stereorectification/', scene, '/im1.', type);

%	Reads the images.
try 
    lImage = imread(pathL, type);
    rImage = imread(pathR, type);
catch
    error = 1;
    return;
end

%   Returns 0 (zero) if everything were fine, or 1 (one) otherwise.
error = 0;

%   Ends the script.
end