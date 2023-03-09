%==========================================================================
%                             RECTIFY IMAGES
%
%   This script is responsible to apply a rectification method in the input
% images, in order to allows the disparity map calculation.
%==========================================================================

function [lImage, rImage, lTrans, tTrans] = ...
    rectifyImages(lPoints, rPoints, F, lImage, rImage)

%   Estimates the projective transformations for the calibration.
[lTrans, tTrans] = ...
    estimateUncalibratedRectification(...
        F, lPoints.Location, rPoints.Location, size(rImage)...
    );

tformL = projective2d(lTrans);
tformR = projective2d(tTrans);

%   Applies the projective transformations on the input images.
lImage = imwarp(lImage, tformL, 'OutputView', imref2d(size(lImage)));
rImage = imwarp(rImage, tformR, 'OutputView', imref2d(size(rImage)));

%   Ends the script.
end